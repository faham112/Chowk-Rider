import os
from datetime import datetime
from typing import Optional

import asyncpg
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

load_dotenv()

app = FastAPI(title="ChowkRider API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DATABASE_URL = os.getenv("DATABASE_URL")
pool: Optional[asyncpg.Pool] = None

STOPS_FALLBACK = [
    {"slug": "daharki-chowk", "name": "Daharki Chowk", "landmark": "Main bazaar", "lat": 28.141, "lng": 69.728, "fee_pkr": 80},
    {"slug": "railway", "name": "Railway Station", "landmark": "Station road", "lat": 28.145, "lng": 69.731, "fee_pkr": 80},
    {"slug": "hospital", "name": "Civil Hospital", "landmark": "Hospital gate", "lat": 28.138, "lng": 69.735, "fee_pkr": 80},
    {"slug": "bypass", "name": "Bypass Adda", "landmark": "National highway", "lat": 28.150, "lng": 69.720, "fee_pkr": 80},
    {"slug": "colony", "name": "Colony Gate", "landmark": "Housing colony", "lat": 28.133, "lng": 69.726, "fee_pkr": 80},
    {"slug": "bus", "name": "New Bus Stand", "landmark": "Coach adda", "lat": 28.147, "lng": 69.740, "fee_pkr": 80},
]
ORDERS_FALLBACK = []
_seq = 1

class OrderIn(BaseModel):
    phone: str
    itemsText: str = ""
    deliveryType: str = "stop"
    stopSlug: Optional[str] = None
    stopName: Optional[str] = None
    homeNote: Optional[str] = None
    notes: Optional[str] = None
    payMethod: str = "cod"

async def init_db():
    global pool
    if not DATABASE_URL:
        return
    pool = await asyncpg.create_pool(DATABASE_URL, min_size=1, max_size=5)
    async with pool.acquire() as conn:
        await conn.execute("""
            CREATE TABLE IF NOT EXISTS stops (
                slug TEXT PRIMARY KEY,
                name TEXT,
                landmark TEXT,
                lat DOUBLE PRECISION,
                lng DOUBLE PRECISION,
                fee_pkr INT DEFAULT 80
            )
        """)
        await conn.execute("""
            CREATE TABLE IF NOT EXISTS orders (
                id SERIAL PRIMARY KEY,
                public_id TEXT UNIQUE,
                customer_phone TEXT,
                items_text TEXT,
                delivery_type TEXT,
                stop_slug TEXT,
                stop_name TEXT,
                home_note TEXT,
                notes TEXT,
                delivery_fee INT,
                pay_method TEXT,
                status TEXT DEFAULT 'open',
                rider_name TEXT,
                created_at TIMESTAMPTZ DEFAULT NOW()
            )
        """)
        for s in STOPS_FALLBACK:
            await conn.execute("""
                INSERT INTO stops (slug, name, landmark, lat, lng, fee_pkr)
                VALUES ($1,$2,$3,$4,$5,$6)
                ON CONFLICT (slug) DO NOTHING
            """, s["slug"], s["name"], s["landmark"], s["lat"], s["lng"], s["fee_pkr"])

@app.on_event("startup")
async def startup():
    await init_db()

@app.on_event("shutdown")
async def shutdown():
    if pool:
        await pool.close()

@app.get("/health")
async def health():
    return {"ok": True, "db": "postgres" if pool else "memory", "name": "chowkrider"}

@app.get("/stops")
async def stops():
    if not pool:
        return STOPS_FALLBACK
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT slug, name, landmark, lat, lng, fee_pkr FROM stops ORDER BY name")
        return [dict(r) for r in rows]

@app.get("/orders/open")
async def open_orders():
    if not pool:
        return [o for o in ORDERS_FALLBACK if o["status"] == "open"]
    async with pool.acquire() as conn:
        rows = await conn.fetch("""
            SELECT id, public_id, customer_phone, items_text, delivery_type, stop_slug,
                   stop_name, home_note, notes, delivery_fee, pay_method, status, rider_name, created_at
            FROM orders WHERE status = 'open' ORDER BY created_at DESC
        """)
        return [dict(r) for r in rows]

@app.post("/orders")
async def create_order(body: OrderIn):
    global _seq
    delivery = "home" if body.deliveryType == "home" else "stop"
    fee = 150 if delivery == "home" else 80
    pay = body.payMethod if body.payMethod in ("cod", "jazzcash") else "cod"
    day = datetime.utcnow().strftime("%Y%m%d")

    if not pool:
        order = {
            "id": _seq,
            "public_id": f"DHK-{day}-{_seq:04d}",
            "customer_phone": body.phone,
            "items_text": body.itemsText,
            "delivery_type": delivery,
            "stop_slug": body.stopSlug,
            "stop_name": body.stopName,
            "home_note": body.homeNote,
            "notes": body.notes,
            "delivery_fee": fee,
            "pay_method": pay,
            "status": "open",
            "created_at": datetime.utcnow().isoformat(),
        }
        _seq += 1
        ORDERS_FALLBACK.append(order)
        return order

    async with pool.acquire() as conn:
        row = await conn.fetchrow("""
            INSERT INTO orders (public_id, customer_phone, items_text, delivery_type,
                                stop_slug, stop_name, home_note, notes, delivery_fee, pay_method, status)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,'open')
            RETURNING id, public_id, customer_phone, items_text, delivery_type, stop_slug,
                      stop_name, home_note, notes, delivery_fee, pay_method, status, created_at
        """, f"DHK-{day}-tmp", body.phone, body.itemsText, delivery,
            body.stopSlug, body.stopName, body.homeNote, body.notes, fee, pay)
        public_id = f"DHK-{day}-{row['id']:04d}"
        await conn.execute("UPDATE orders SET public_id = $1 WHERE id = $2", public_id, row["id"])
        d = dict(row)
        d["public_id"] = public_id
        return d

@app.post("/orders/{order_id}/accept")
async def accept(order_id: int, riderName: str = "Rider"):
    if not pool:
        for o in ORDERS_FALLBACK:
            if o["id"] == order_id and o["status"] == "open":
                o["status"] = "accepted"
                o["rider_name"] = riderName
                return o
        raise HTTPException(409, "not_open")
    async with pool.acquire() as conn:
        row = await conn.fetchrow("""
            UPDATE orders SET status = 'accepted', rider_name = $2
            WHERE id = $1 AND status = 'open'
            RETURNING id, public_id, status, rider_name
        """, order_id, riderName)
        if not row:
            raise HTTPException(409, "not_open")
        return dict(row)

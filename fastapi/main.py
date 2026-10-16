import os
from datetime import datetime
from typing import Optional

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

# In-memory fallback (Mongo optional)
STOPS = [
    {"slug": "daharki-chowk", "name": "Daharki Chowk", "landmark": "Main bazaar", "lat": 28.141, "lng": 69.728, "feePkr": 80},
    {"slug": "railway", "name": "Railway Station", "landmark": "Station road", "lat": 28.145, "lng": 69.731, "feePkr": 80},
    {"slug": "hospital", "name": "Civil Hospital", "landmark": "Hospital gate", "lat": 28.138, "lng": 69.735, "feePkr": 80},
    {"slug": "bypass", "name": "Bypass Adda", "landmark": "National highway", "lat": 28.150, "lng": 69.720, "feePkr": 80},
    {"slug": "colony", "name": "Colony Gate", "landmark": "Housing colony", "lat": 28.133, "lng": 69.726, "feePkr": 80},
    {"slug": "bus", "name": "New Bus Stand", "landmark": "Coach adda", "lat": 28.147, "lng": 69.740, "feePkr": 80},
]
ORDERS = []
_id = 1

class OrderIn(BaseModel):
    phone: str
    itemsText: str = ""
    deliveryType: str = "stop"
    stopSlug: Optional[str] = None
    stopName: Optional[str] = None
    homeNote: Optional[str] = None
    notes: Optional[str] = None
    payMethod: str = "cod"

@app.get("/health")
def health():
    return {"ok": True, "db": "memory" if not os.getenv("MONGODB_URI") else "mongo", "name": "chowkrider"}

@app.get("/stops")
def stops():
    return STOPS

@app.get("/orders/open")
def open_orders():
    return [o for o in ORDERS if o["status"] == "open"]

@app.post("/orders")
def create_order(body: OrderIn):
    global _id
    day = datetime.utcnow().strftime("%Y%m%d")
    delivery = "home" if body.deliveryType == "home" else "stop"
    order = {
        "id": str(_id),
        "publicId": f"DHK-{day}-{_id:04d}",
        "customerPhone": body.phone,
        "itemsText": body.itemsText,
        "deliveryType": delivery,
        "stopSlug": body.stopSlug,
        "stopName": body.stopName,
        "homeNote": body.homeNote,
        "notes": body.notes,
        "deliveryFee": 150 if delivery == "home" else 80,
        "payMethod": body.payMethod if body.payMethod in ("cod", "jazzcash") else "cod",
        "status": "open",
        "createdAt": datetime.utcnow().isoformat(),
    }
    _id += 1
    ORDERS.append(order)
    return order

@app.post("/orders/{order_id}/accept")
def accept(order_id: str, riderName: str = "Rider"):
    for o in ORDERS:
        if o["id"] == order_id and o["status"] == "open":
            o["status"] = "accepted"
            o["riderName"] = riderName
            return o
    raise HTTPException(409, "not_open")

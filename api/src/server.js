import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import cors from 'cors';
import express from 'express';
import { connectDb } from './db.js';
import { Order, Stop } from './models.js';
import { seedStops } from './seed.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const envPath = path.join(__dirname, '..', '.env');
if (fs.existsSync(envPath)) {
  for (const line of fs.readFileSync(envPath, 'utf8').split('\n')) {
    const t = line.trim();
    if (!t || t.startsWith('#') || !t.includes('=')) continue;
    const i = t.indexOf('=');
    const k = t.slice(0, i);
    const v = t.slice(i + 1);
    if (!process.env[k]) process.env[k] = v;
  }
}

const app = express();
app.use(cors());
app.use(express.json());

app.get('/health', async (_req, res) => {
  const mongoose = (await import('mongoose')).default;
  const state = ['disconnected', 'connected', 'connecting', 'disconnecting'][mongoose.connection.readyState];
  res.json({ ok: true, db: state, name: 'chowkrider' });
});

app.get('/stops', async (_req, res) => {
  res.json(await Stop.find().sort({ name: 1 }).lean());
});

app.get('/orders/open', async (_req, res) => {
  res.json(await Order.find({ status: 'open' }).sort({ createdAt: -1 }).lean());
});

app.get('/orders/mine', async (req, res) => {
  const phone = String(req.query.phone || '');
  res.json(await Order.find({ customerPhone: phone }).sort({ createdAt: -1 }).lean());
});

app.post('/orders', async (req, res) => {
  const body = req.body || {};
  const day = new Date().toISOString().slice(0, 10).replaceAll('-', '');
  const n = (await Order.countDocuments()) + 1;
  const deliveryType = body.deliveryType === 'home' ? 'home' : 'stop';
  const order = await Order.create({
    publicId: `DHK-${day}-${String(n).padStart(4, '0')}`,
    customerPhone: body.phone,
    itemsText: body.itemsText || '',
    deliveryType,
    stopSlug: body.stopSlug,
    stopName: body.stopName,
    homeNote: body.homeNote,
    notes: body.notes,
    deliveryFee: deliveryType === 'home' ? 150 : 80,
    payMethod: body.payMethod === 'jazzcash' ? 'jazzcash' : 'cod',
    status: 'open',
  });
  res.status(201).json(order);
});

app.post('/orders/:id/accept', async (req, res) => {
  const order = await Order.findById(req.params.id);
  if (!order || order.status !== 'open') {
    return res.status(409).json({ error: 'not_open' });
  }
  order.status = 'accepted';
  order.riderName = req.body?.riderName || 'Rider';
  await order.save();
  res.json(order);
});

const port = Number(process.env.PORT || 8080);

connectDb()
  .then(async (conn) => {
    await seedStops();
    console.log('Mongo connected', conn.name, conn.host);
    app.listen(port, () => console.log('API on', port));
  })
  .catch((err) => {
    console.error('Mongo failed', err.message);
    process.exit(1);
  });

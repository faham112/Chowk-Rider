# ChowkRider API

MongoDB Atlas + Express. Copy `.env.example` to `.env` and put your URI. Never commit `.env`.

```bash
cd api
cp .env.example .env
npm install
npm start
```

Atlas Network Access: allow your IP or `0.0.0.0/0` for testing.

- GET /health
- GET /stops
- GET /orders/open
- GET /orders/mine?phone=03XXXXXXXXX
- POST /orders
- POST /orders/:id/accept

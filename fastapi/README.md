# ChowkRider FastAPI

Python 3.10+ + FastAPI. Termux pe chalane ke liye neeche steps.

## Termux setup

```bash
pkg update && pkg upgrade -y
pkg install python git -y
cd ~
git clone https://github.com/faham112/Chowk-Rider.git
cd Chowk-Rider/fastapi
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

`.env` banao (Mongo URI daalo):

```bash
cp .env.example .env
nano .env   # MONGODB_URI=...
```

Chalao:

```bash
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000
```

Phone se test: `http://<termiux-ip>:8000/health`

## Endpoints

- `GET /health`
- `GET /stops`
- `POST /orders`  `{ "phone": "03xx", "itemsText": "...", "deliveryType": "stop", "stopSlug": "daharki-chowk" }`
- `GET /orders/open`
- `POST /orders/{id}/accept`

Mongo nahi hai to bhi chalega (in-memory). Atlas chahiye to `.env` mein URI do.

# ChowkRider — Locked Plan

Local shopping + delivery for **Daharki, District Ghotki, Sindh, Pakistan**.

**Brand:** **ChowkRider** (locked 2026-09-24). GitHub: **Chowk-Rider**. Spoken: “Chowk Rider”. No space in app/store name.
**Status:** everything below is **LOCKED**.

Repo: https://github.com/faham112/Chowk-Rider

## Locked decisions

| Topic | Decision |
|--------|----------|
| Brand | **ChowkRider**. App, SMS, bikes, admin: this name. |
| City | Daharki only. No second city in v1. |
| Hours | 08:00–20:00. New orders stop at 19:00. |
| Fleet | Company bikes + hired riders. Start 2–5 riders. |
| What we sell | No inventory. Rider shops the customer list in the bazaar. |
| Order input | Typed list + optional photo. No product catalog in v1. |
| Delivery | Stops default PKR 80. Home pin PKR 150. |
| Batching | Max 3 small orders / 20 min. |
| Payment | COD always. JazzCash MWALLET when merchant keys exist. |
| Wallet | OFF for v1. |
| Rider pay | PKR 40 per delivered order. |
| Notify | Arrived SMS: `ChowkRider: Saman aa gaya hai — [stop]`. |
| Live map | No Careem-style tracking in v1. |
| Stack | Flutter app + Laravel API + PostgreSQL on Hostinger KVM 1 Mumbai. |
| Auth | Phone OTP. |
| Order id | `DHK-YYYYMMDD-0001`. |

## App

Flutter source in `app/`. Demo OTP: `1234`.

```bash
cd app
flutter pub get
flutter run
```

## Next to add

1. Laravel API + PostgreSQL — replace MockStore
2. Real OTP SMS
3. Bill + list photo upload
4. Admin web (riders, float, mark paid)
5. Real Daharki stop GPS
6. Push + SMS on Arrived
7. JazzCash MWALLET after keys
8. Play Store after 20–30 WhatsApp orders

Do not add yet: wallet, live map, multi-city, shop catalog.

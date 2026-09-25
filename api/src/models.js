import mongoose from 'mongoose';

const stopSchema = new mongoose.Schema(
  {
    slug: { type: String, unique: true, required: true },
    name: String,
    landmark: String,
    lat: Number,
    lng: Number,
    feePkr: { type: Number, default: 80 },
  },
  { timestamps: true },
);

const orderSchema = new mongoose.Schema(
  {
    publicId: { type: String, unique: true, required: true },
    customerPhone: String,
    itemsText: String,
    deliveryType: { type: String, enum: ['stop', 'home'], default: 'stop' },
    stopSlug: String,
    stopName: String,
    homeNote: String,
    notes: String,
    deliveryFee: Number,
    payMethod: { type: String, enum: ['cod', 'jazzcash'], default: 'cod' },
    status: {
      type: String,
      default: 'open',
      enum: ['draft', 'open', 'accepted', 'shopping', 'billed', 'on_the_way', 'arrived', 'delivered', 'cancelled', 'disputed'],
    },
    riderName: String,
    shopName: String,
    subtotal: { type: Number, default: 0 },
  },
  { timestamps: true },
);

export const Stop = mongoose.model('Stop', stopSchema);
export const Order = mongoose.model('Order', orderSchema);

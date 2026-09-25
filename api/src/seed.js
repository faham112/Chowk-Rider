import { Stop } from './models.js';

const stops = [
  { slug: 'daharki-chowk', name: 'Daharki Chowk', landmark: 'Main bazaar chowk', lat: 28.141, lng: 69.728 },
  { slug: 'railway', name: 'Railway Station', landmark: 'Station road', lat: 28.145, lng: 69.731 },
  { slug: 'hospital', name: 'Civil Hospital', landmark: 'Hospital gate', lat: 28.138, lng: 69.735 },
  { slug: 'bypass', name: 'Bypass Adda', landmark: 'National highway adda', lat: 28.150, lng: 69.720 },
  { slug: 'colony', name: 'Colony Gate', landmark: 'Housing colony', lat: 28.133, lng: 69.726 },
  { slug: 'bus', name: 'New Bus Stand', landmark: 'Coach adda', lat: 28.147, lng: 69.740 },
];

export async function seedStops() {
  for (const s of stops) {
    await Stop.updateOne({ slug: s.slug }, { $set: s }, { upsert: true });
  }
}

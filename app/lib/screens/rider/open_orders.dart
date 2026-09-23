import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../theme/colors.dart';
import 'active_order.dart';

class RiderOpenOrdersScreen extends StatelessWidget {
  const RiderOpenOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final open = store.openOrders;
    return ColoredBox(
      color: CrColors.forestDeep,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('ChowkRider Rider', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Batch: ${store.batchCount}/3 orders  •  20 min max', style: const TextStyle(color: Color(0xFF95D5B2))),
            const SizedBox(height: 18),
            const Text('Open orders', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            if (open.isEmpty) const Text('Koi open order nahi', style: TextStyle(color: Colors.white54)),
            for (final o in open) _card(context, store, o),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, MockStore store, CrOrder o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF12261C), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(o.publicId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(o.itemsText, style: const TextStyle(color: Colors.white70)),
          Text(o.stopName ?? o.homeNote ?? '', style: const TextStyle(color: CrColors.mustard)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final ok = store.accept(o, 'Ali Rider');
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accept nahi ho saka')));
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => RiderActiveOrderScreen(orderId: o.id)));
              },
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../theme/colors.dart';
import '../../widgets/status_stepper.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final order = store.byId(orderId);
    if (order == null) return const Scaffold(body: Center(child: Text('Order nahi mili')));
    final arrived = order.status == CrOrderStatus.arrived || order.status == CrOrderStatus.delivered;
    return Scaffold(
      backgroundColor: CrColors.forestDeep,
      appBar: AppBar(backgroundColor: CrColors.forestDeep, title: Text(order.publicId)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StatusStepper(status: order.status, dark: true),
          const SizedBox(height: 16),
          if (arrived)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1B3A2A), borderRadius: BorderRadius.circular(14), border: Border.all(color: CrColors.mustard)),
              child: Text(store.arrivalSms(order), style: const TextStyle(color: CrColors.mustard, fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          const SizedBox(height: 16),
          Text(order.riderName ?? 'Rider assign hone wala hai', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(order.stopName ?? order.homeNote ?? 'Location', style: const TextStyle(color: CrColors.mustard)),
          Text(order.itemsText, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text('Total Rs ${order.total} • ${order.payMethod == CrPayMethod.cod ? 'COD' : 'JazzCash'}', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          if (arrived && order.status != CrOrderStatus.delivered)
            FilledButton(onPressed: () => store.markDelivered(order), child: const Text('Saman mil gaya')),
        ],
      ),
    );
  }
}

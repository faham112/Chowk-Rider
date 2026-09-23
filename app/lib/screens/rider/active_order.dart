import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';

class RiderActiveOrderScreen extends StatefulWidget {
  const RiderActiveOrderScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<RiderActiveOrderScreen> createState() => _RiderActiveOrderScreenState();
}

class _RiderActiveOrderScreenState extends State<RiderActiveOrderScreen> {
  final _shop = TextEditingController(text: 'Memon Store');
  final _sub = TextEditingController(text: '1850');
  @override
  void dispose() {
    _shop.dispose();
    _sub.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final order = store.byId(widget.orderId);
    if (order == null) return const Scaffold(body: Center(child: Text('Order nahi mili')));
    return Scaffold(
      appBar: AppBar(title: Text('Active ${order.publicId}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(order.itemsText, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(order.stopName ?? '', style: const TextStyle(color: CrColors.muted)),
          const SizedBox(height: 16),
          TextField(controller: _shop, decoration: const InputDecoration(labelText: 'Shop name')),
          const SizedBox(height: 8),
          TextField(controller: _sub, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subtotal Rs')),
          const SizedBox(height: 12),
          CrPrimaryButton(label: 'Bill upload', onTap: () => store.uploadBill(order, shop: _shop.text.trim(), subtotal: int.tryParse(_sub.text) ?? 0)),
          const SizedBox(height: 12),
          CrGhostButton(label: 'On the way', onTap: () => store.setStatus(order, CrOrderStatus.onTheWay)),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: CrColors.forest),
            onPressed: () {
              store.setStatus(order, CrOrderStatus.arrived);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(store.arrivalSms(order))));
            },
            child: const Text('Arrived — customer ko msg', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

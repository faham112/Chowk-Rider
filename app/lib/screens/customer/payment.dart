import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.deliveryFee, required this.selected, this.subtotal = 0});
  final int deliveryFee;
  final int subtotal;
  final CrPayMethod selected;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late CrPayMethod _method = widget.selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Payment', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Text('Delivery fee Rs ${widget.deliveryFee}'),
          const SizedBox(height: 16),
          CrSelectCard(selected: _method == CrPayMethod.cod, title: 'Cash on delivery', subtitle: 'Rider ko cash do', onTap: () => setState(() => _method = CrPayMethod.cod)),
          const SizedBox(height: 8),
          CrSelectCard(selected: _method == CrPayMethod.jazzcash, title: 'JazzCash wallet', subtitle: 'PIN JazzCash pe', onTap: () => setState(() => _method = CrPayMethod.jazzcash)),
          const SizedBox(height: 8),
          const Opacity(opacity: 0.45, child: IgnorePointer(child: CrSelectCard(selected: false, title: 'Wallet', subtitle: 'v1 mein nahi', onTap: _noop))),
          const SizedBox(height: 16),
          Text('Merchant keys se pehle: ${MockStore.companyJazzNumber}', style: const TextStyle(color: CrColors.muted, fontSize: 12)),
          const SizedBox(height: 24),
          CrPrimaryButton(label: 'Confirm', onTap: () => Navigator.pop(context, _method)),
        ],
      ),
    );
  }
}
void _noop() {}

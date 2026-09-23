import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../models/stop.dart';
import '../../state/session.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';
import 'choose_stop.dart';
import 'payment.dart';
import 'track_order.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});
  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _items = TextEditingController();
  final _notes = TextEditingController();
  CrDeliveryType _type = CrDeliveryType.stop;
  CrPayMethod _pay = CrPayMethod.cod;
  CrStop? _stop;
  String? _error;
  @override
  void dispose() {
    _items.dispose();
    _notes.dispose();
    super.dispose();
  }
  Future<void> _pickStop() async {
    final picked = await Navigator.of(context).push<CrStop>(MaterialPageRoute(builder: (_) => ChooseStopScreen(selectedId: _stop?.id)));
    if (picked != null) setState(() => _stop = picked);
  }
  void _submit() {
    if (_items.text.trim().isEmpty) {
      setState(() => _error = 'List likho');
      return;
    }
    if (_type == CrDeliveryType.stop && _stop == null) {
      setState(() => _error = 'Pehle stop choose karo');
      return;
    }
    Navigator.of(context).push<CrPayMethod>(MaterialPageRoute(builder: (_) => PaymentScreen(deliveryFee: _type == CrDeliveryType.stop ? MockStore.stopFee : MockStore.homeFee, selected: _pay))).then((pay) {
      if (pay == null || !mounted) return;
      final session = SessionScope.of(context);
      final store = StoreScope.of(context);
      final order = store.createOrder(phone: session.phone!, items: _items.text.trim(), type: _type, pay: pay, stop: _stop, homeNote: _type == CrDeliveryType.home ? 'Home pin' : null, notes: _notes.text.trim().isEmpty ? null : _notes.text.trim());
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: order.id)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChowkRider')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Naya order', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: CrColors.forest)),
          const SizedBox(height: 16),
          TextField(controller: _items, minLines: 3, maxLines: 5, decoration: const InputDecoration(hintText: '1 kg cheeni, 2 bread, oil 1 litre')),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: CrSelectCard(selected: _type == CrDeliveryType.stop, title: 'Stop — Rs ${MockStore.stopFee}', subtitle: _stop?.name ?? 'Stop choose karo', onTap: () { setState(() => _type = CrDeliveryType.stop); _pickStop(); })),
            const SizedBox(width: 8),
            Expanded(child: CrSelectCard(selected: _type == CrDeliveryType.home, title: 'Ghar pin — Rs ${MockStore.homeFee}', onTap: () => setState(() => _type = CrDeliveryType.home))),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes (optional)')),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: CrColors.danger))),
          const SizedBox(height: 24),
          CrPrimaryButton(label: 'Order bhejo', onTap: _submit),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/stop.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';

class ChooseStopScreen extends StatefulWidget {
  const ChooseStopScreen({super.key, this.selectedId});
  final String? selectedId;
  @override
  State<ChooseStopScreen> createState() => _ChooseStopScreenState();
}

class _ChooseStopScreenState extends State<ChooseStopScreen> {
  late String? _id = widget.selectedId;
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final list = store.stops.where((s) => _q.isEmpty || s.name.toLowerCase().contains(_q.toLowerCase()) || s.landmark.toLowerCase().contains(_q.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Apna stop choose karo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(onChanged: (v) => setState(() => _q = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Stop dhundo...')),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final s = list[i];
                final on = s.id == _id;
                return InkWell(
                  onTap: () => setState(() => _id = s.id),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: on ? const Color(0xFFE8F5E9) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: on ? CrColors.forest : CrColors.line, width: on ? 1.8 : 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: CrColors.forest),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800)), Text(s.landmark, style: const TextStyle(color: CrColors.muted, fontSize: 12))])),
                        Text('Rs ${MockStore.stopFee}', style: TextStyle(color: on ? CrColors.forest : CrColors.muted, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CrPrimaryButton(
              label: 'Yahi stop',
              onTap: _id == null ? null : () {
                final stop = store.stops.firstWhere((s) => s.id == _id);
                Navigator.pop<CrStop>(context, stop);
              },
            ),
          ),
        ],
      ),
    );
  }
}

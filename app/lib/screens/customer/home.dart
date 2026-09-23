import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../models/order.dart';
import '../../state/session.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';
import '../role_gate.dart';
import 'new_order.dart';
import 'track_order.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final store = StoreScope.of(context);
    final mine = store.mine(session.phone ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChowkRider'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              session.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleGateScreen()),
                (r) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Salam, ${session.phone}', style: const TextStyle(color: CrColors.muted)),
          const SizedBox(height: 6),
          const Text('Bazaar se kya lana hai?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: CrColors.forest)),
          const SizedBox(height: 16),
          CrPrimaryButton(
            label: 'Naya order',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewOrderScreen()));
            },
          ),
          const SizedBox(height: 24),
          const Text('Mere orders', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (mine.isEmpty) const Text('Abhi koi order nahi', style: TextStyle(color: CrColors.muted)),
          for (final o in mine)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: CrColors.line)),
                title: Text(o.publicId, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${o.itemsText}\n${statusLabel(o.status)}'),
                isThreeLine: true,
                trailing: Text('Rs ${o.deliveryFee}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: o.id)));
                },
              ),
            ),
        ],
      ),
    );
  }
}

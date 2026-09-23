import 'package:flutter/material.dart';
import '../../data/mock_store.dart';
import '../../state/session.dart';
import '../../theme/colors.dart';
import '../role_gate.dart';
import 'open_orders.dart';

class RiderShell extends StatefulWidget {
  const RiderShell({super.key});
  @override
  State<RiderShell> createState() => _RiderShellState();
}

class _RiderShellState extends State<RiderShell> {
  int _i = 0;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final pages = [
      const RiderOpenOrdersScreen(),
      _panel('Active', 'Accepted orders yahan list honge jab batch chal raha ho.'),
      _panel('Shift', 'Hours locked 08:00–20:00. Naye order 19:00 band.'),
      _panel('Cash', 'Float Rs ${store.floatPkr}\nPer delivered order Rs ${MockStore.riderPayPerOrder}'),
    ];
    return Scaffold(
      body: pages[_i],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (v) => setState(() => _i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.two_wheeler), label: 'Active'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Shift'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), label: 'Cash'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CrColors.forest,
        foregroundColor: Colors.white,
        onPressed: () {
          SessionScope.of(context).logout();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const RoleGateScreen()), (r) => false);
        },
        label: const Text('Logout'),
        icon: const Icon(Icons.logout),
      ),
    );
  }

  Widget _panel(String title, String body) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: CrColors.forest)),
          const SizedBox(height: 12),
          Text(body, style: const TextStyle(height: 1.45, fontSize: 16)),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'data/mock_store.dart';
import 'screens/role_gate.dart';
import 'state/session.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChowkRiderApp());
}

class ChowkRiderApp extends StatefulWidget {
  const ChowkRiderApp({super.key});

  @override
  State<ChowkRiderApp> createState() => _ChowkRiderAppState();
}

class _ChowkRiderAppState extends State<ChowkRiderApp> {
  final _session = CrSession();
  final _store = MockStore();

  @override
  void dispose() {
    _session.dispose();
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      session: _session,
      child: StoreScope(
        store: _store,
        child: MaterialApp(
          title: 'ChowkRider',
          debugShowCheckedModeBanner: false,
          theme: CrTheme.light(),
          home: const RoleGateScreen(),
        ),
      ),
    );
  }
}

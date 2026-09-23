import 'package:flutter/material.dart';

import '../../data/mock_store.dart';
import '../../state/session.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';
import '../customer/home.dart';
import '../rider/shell.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.phone});
  final String phone;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _verify() {
    if (_ctrl.text.trim() != MockStore.demoOtp) {
      setState(() => _error = 'Galat OTP. Demo: ${MockStore.demoOtp}');
      return;
    }
    final session = SessionScope.of(context);
    session.login(widget.phone);
    final home = session.role == CrRole.rider ? const RiderShell() : const CustomerHomeScreen();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => home),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.phone, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: CrColors.ink)),
            const SizedBox(height: 8),
            const Text('4 digit code likho', style: TextStyle(color: CrColors.muted)),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'OTP', errorText: _error),
            ),
            const Spacer(),
            CrPrimaryButton(label: 'Verify', onTap: _verify),
          ],
        ),
      ),
    );
  }
}

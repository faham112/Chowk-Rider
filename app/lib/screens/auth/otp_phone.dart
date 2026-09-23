import 'package:flutter/material.dart';

import '../../state/session.dart';
import '../../theme/colors.dart';
import '../../widgets/cr_button.dart';
import 'otp_verify.dart';

class OtpPhoneScreen extends StatefulWidget {
  const OtpPhoneScreen({super.key});

  @override
  State<OtpPhoneScreen> createState() => _OtpPhoneScreenState();
}

class _OtpPhoneScreenState extends State<OtpPhoneScreen> {
  final _ctrl = TextEditingController(text: '0300');
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final raw = _ctrl.text.replaceAll(RegExp(r'\s|-'), '');
    if (!RegExp(r'^03\d{9}$').hasMatch(raw)) {
      setState(() => _error = '03XX XXXXXXX format mein number likho');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OtpVerifyScreen(phone: raw)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = SessionScope.of(context).role;
    return Scaffold(
      appBar: AppBar(
        title: Text(role == CrRole.rider ? 'Rider login' : 'Customer login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mobile number', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: CrColors.ink)),
            const SizedBox(height: 6),
            const Text('OTP SMS se aayega. Demo code: 1234', style: TextStyle(color: CrColors.muted)),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: '03XXXXXXXXX', errorText: _error),
            ),
            const Spacer(),
            CrPrimaryButton(label: 'OTP bhejo', onTap: _send),
          ],
        ),
      ),
    );
  }
}

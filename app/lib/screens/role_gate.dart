import 'package:flutter/material.dart';

import '../state/session.dart';
import '../theme/colors.dart';
import '../widgets/cr_button.dart';
import 'auth/otp_phone.dart';

class RoleGateScreen extends StatelessWidget {
  const RoleGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CrColors.forestDeep, CrColors.forest],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              children: [
                const Icon(Icons.two_wheeler, color: CrColors.mustard, size: 64),
                const SizedBox(height: 12),
                const Text(
                  'ChowkRider',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const Text('Daharki', style: TextStyle(color: CrColors.mustard, fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Bazaar se saman le aao.\nStop ya ghar — subah se shaam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
                const Spacer(),
                CrPrimaryButton(label: 'Customer', onTap: () => _go(context, CrRole.customer)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _go(context, CrRole.rider),
                    child: const Text('Rider'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('v1 mock — OTP demo 1234', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, CrRole role) {
    SessionScope.of(context).setRole(role);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OtpPhoneScreen()));
  }
}

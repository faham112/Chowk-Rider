import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/colors.dart';

class StatusStepper extends StatelessWidget {
  const StatusStepper({super.key, required this.status, this.dark = false});
  final CrOrderStatus status;
  final bool dark;
  static const steps = [
    CrOrderStatus.open,
    CrOrderStatus.accepted,
    CrOrderStatus.shopping,
    CrOrderStatus.billed,
    CrOrderStatus.onTheWay,
    CrOrderStatus.arrived,
    CrOrderStatus.delivered,
  ];
  @override
  Widget build(BuildContext context) {
    final idx = steps.indexOf(status);
    final active = idx < 0 ? 0 : idx;
    final text = dark ? Colors.white : CrColors.ink;
    final dim = dark ? Colors.white54 : CrColors.muted;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    i < active ? Icons.check_circle : i == active ? Icons.radio_button_checked : Icons.circle_outlined,
                    color: i <= active ? CrColors.mustard : dim,
                    size: 20,
                  ),
                  if (i != steps.length - 1) Container(width: 2, height: 18, color: i < active ? CrColors.mustard : dim),
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  statusLabel(steps[i]),
                  style: TextStyle(color: i <= active ? text : dim, fontWeight: i == active ? FontWeight.w800 : FontWeight.w500),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

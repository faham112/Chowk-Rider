import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CrPrimaryButton extends StatelessWidget {
  const CrPrimaryButton({super.key, required this.label, required this.onTap, this.expand = true});
  final String label;
  final VoidCallback? onTap;
  final bool expand;
  @override
  Widget build(BuildContext context) {
    final child = FilledButton(onPressed: onTap, child: Text(label));
    if (!expand) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}

class CrGhostButton extends StatelessWidget {
  const CrGhostButton({super.key, required this.label, required this.onTap, this.expand = true});
  final String label;
  final VoidCallback? onTap;
  final bool expand;
  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton(onPressed: onTap, child: Text(label));
    if (!expand) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}

class CrSelectCard extends StatelessWidget {
  const CrSelectCard({super.key, required this.selected, required this.title, this.subtitle, required this.onTap});
  final bool selected;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? CrColors.forest : CrColors.line, width: selected ? 1.8 : 1),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? CrColors.forest : CrColors.muted, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: CrColors.ink)),
                  if (subtitle != null) Text(subtitle!, style: const TextStyle(color: CrColors.muted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

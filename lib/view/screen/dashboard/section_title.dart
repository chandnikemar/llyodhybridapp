import 'package:flutter/material.dart';

import '../../../utilities/common_text.dart';
// ---------- Section title ----------
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF131754),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_text.dart';

class WelcomeHeader extends StatefulWidget {
  final String firstName;

  const WelcomeHeader({super.key, required this.firstName});

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // A timer that ticks every minute to keep the greeting and date accurate
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Always cancel the timer to prevent memory leaks
    super.dispose();
  }

  // Helper method to get 'st', 'nd', 'rd', 'th'
  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Helper method to format date as "8th August"
  String _getFormattedDate() {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final day = _now.day;
    final month = months[_now.month - 1];
    return '$day${_getOrdinalSuffix(day)} $month';
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        widget.firstName.isNotEmpty ? widget.firstName : 'there';

    // Toggle between morning and evening (17 = 5:00 PM)
    final isMorning = _now.hour < 17;
    final iconPath = isMorning
        ? 'assets/images/dash_morning.svg'
        : 'assets/images/dash_evening.svg'; // Ensure you have an evening icon in your assets

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // Change to center to align the icon vertically with the entire column
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          // Ensure the column only takes up the required vertical space
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              'Welcome back, $displayName',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF131754),
            ),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CommonText.caption(
                  _getFormattedDate(),
                  color: AppColors.headerBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10,),
              CommonText.caption(
                "Overview",
                color: AppColors.greyColor,
                fontWeight: FontWeight.bold,
              ),
            ]),
          ],
        ),
        const SizedBox(width: 10),
        SvgPicture.asset(
          iconPath,
          width: 38,
          height: 38,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'app_colors.dart';
import 'common.dart';

class CommonHeader extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final bool showNotificationDot;

  const CommonHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onAvatarTap,
    this.showNotificationDot = false,
  });

  @override
  State<CommonHeader> createState() => _CommonHeaderState();
}

class _CommonHeaderState extends State<CommonHeader> {
  String _initials = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitials();
  }

  Future<void> _loadInitials() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString(Common.firstName) ?? '';
    final lastName = prefs.getString(Common.lastName) ?? '';

    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    if (!mounted) return;
    setState(() {
      _initials = (firstInitial + lastInitial).toUpperCase();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/ut_logo_without_bg.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 8),
        InkWell(
          onTap: _isLoading ? null : widget.onAvatarTap,
          customBorder: const CircleBorder(),
          child: _isLoading
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? Colors.grey,
            highlightColor: Colors.grey[100] ?? Colors.grey,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          )
              : CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.kHeaderPrimaryBlue,
            child: Text(
              _initials.isNotEmpty ? _initials : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class CommonPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;

  const CommonPageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          InkWell(
            onTap: onBack ?? () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFE5F3FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 20,
                color: Color(0xFF0D82CA),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F3659),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
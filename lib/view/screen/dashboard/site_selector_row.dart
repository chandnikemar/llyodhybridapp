import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities/common_text.dart';
import '../../../utilities/common.dart';

class SiteSelectorRow extends StatefulWidget {
  final ValueChanged<String> onSiteChanged;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMenuPressed;
  final Function(String)? onNavigate;

  const SiteSelectorRow({
    super.key,
    required this.onSiteChanged,
    this.onSearchPressed,
    this.onMenuPressed,
    this.onNavigate,
  });

  @override
  State<SiteSelectorRow> createState() => _SiteSelectorRowState();
}

class _SiteSelectorRowState extends State<SiteSelectorRow> {

  List<Map<String, dynamic>> _tenants = [];
  Map<String, dynamic>? _selectedTenant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  Future<void> _loadTenants() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch the JSON string from SharedPreferences
    final tenantsString = prefs.getString(Common.userTenants);
    final savedTenantCode = prefs.getString(Common.selectedTenant); // Check if one is already saved

    if (tenantsString != null && tenantsString.isNotEmpty) {
      try {
        final List<dynamic> decodedList = jsonDecode(tenantsString);

        // Filter out duplicate tenantCodes
        final Map<String, Map<String, dynamic>> uniqueTenants = {};
        for (var item in decodedList) {
          if (item['tenantCode'] != null) {
            uniqueTenants[item['tenantCode']] = item as Map<String, dynamic>;
          }
        }

        final tenants = uniqueTenants.values.toList();
        Map<String, dynamic>? defaultTenant;

        // 1. Try to load the previously saved tenant first (case-insensitive)
        if (savedTenantCode != null && savedTenantCode.isNotEmpty) {
          try {
            defaultTenant = tenants.firstWhere((t) =>
            (t['tenantCode'] ?? '').toString().trim().toUpperCase() == savedTenantCode.trim().toUpperCase()
            );
          } catch (_) {
            // Not found, fallback to default logic
          }
        }

        // 2. If no saved tenant found, try to find the one where isDefault == true
        if (defaultTenant == null) {
          for (var t in tenants) {
            if (t['isDefault'] == true) {
              defaultTenant = t;
              break;
            }
          }
        }

        // 3. Fallback to the first one in the list if nothing else matches
        if (defaultTenant == null && tenants.isNotEmpty) {
          defaultTenant = tenants.first;
        }

        setState(() {
          _tenants = tenants;
          _selectedTenant = defaultTenant;
          _isLoading = false;
        });

        // Notify parent (DashboardScreen) about the initial selection
        if (_selectedTenant != null) {
          final initialCode = _selectedTenant!['tenantCode'];
          await prefs.setString(Common.selectedTenant, initialCode);
          widget.onSiteChanged(initialCode);
        }
      } catch (e) {
        debugPrint("Error parsing tenants: $e");
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tenant Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FA),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/dash_switch_tenant_dropdown_icon.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF131754),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),

              // Show a loader while parsing, or the Dropdown when ready
              _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTenant?['tenantCode'],
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF131754)),
                  isDense: true,
                  dropdownColor: Colors.white,

                  // 🔹 FIXED ONCHANGED: Async, correct pref saving, and notifying dashboard
                  onChanged: (String? newTenantCode) async {
                    if (newTenantCode != null) {

                      // 1. Update Dropdown UI
                      setState(() {
                        _selectedTenant = _tenants.firstWhere((t) => t['tenantCode'] == newTenantCode);
                      });

                      // 2. Properly initialize SharedPreferences and save the raw string
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(Common.selectedTenant, newTenantCode);

                      // 3. Inform DashboardScreen so it triggers all APIs with "LKOP"
                      widget.onSiteChanged(newTenantCode);
                    }
                  },
                  items: _tenants.map<DropdownMenuItem<String>>((Map<String, dynamic> tenant) {
                    return DropdownMenuItem<String>(
                      value: tenant['tenantCode'],
                      child: CommonText.h3(
                        tenant['tenantName'] ?? 'Unknown Site',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF131754),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // // Search and Menu Icons
        // Row(
        //   children: [
        //     // Search Icon
        //     Container(
        //       width: 36,
        //       height: 36,
        //       decoration: BoxDecoration(
        //         color: const Color(0xFFEAF0FA),
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.search, size: 18, color: Color(0xFF131754)),
        //         onPressed: widget.onSearchPressed,
        //         padding: EdgeInsets.zero,
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     // Menu Icon
        //     Container(
        //       width: 36,
        //       height: 36,
        //       decoration: BoxDecoration(
        //         color: const Color(0xFFEAF0FA),
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.menu, size: 18, color: Color(0xFF131754)),
        //         onPressed: widget.onMenuPressed,
        //         padding: EdgeInsets.zero,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
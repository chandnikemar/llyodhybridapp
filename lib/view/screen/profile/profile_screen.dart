import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/view/screen/profile/change_password_screen.dart';

// Adjust these import paths if they are different in your project structure
import '../../../utilities/common.dart';
import '../../../utilities/common_text.dart';

class ProfileScreen extends StatefulWidget {
  // Callback parameter to navigate backward internally
  final VoidCallback onBackPressed;

  const ProfileScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Data Variables
  String _fullName = '';
  String _initials = '';
  String _roleName = '';
  String _phone = '';
  String _email = '';

  // Tenant Data Variables
  List<Map<String, dynamic>> _tenants = [];
  Map<String, dynamic>? _selectedTenant;
  bool _isLoadingTenants = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTenants();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final String firstName = prefs.getString(Common.firstName) ?? '';
    final String lastName = prefs.getString(Common.lastName) ?? '';
    final String email = prefs.getString(Common.email) ?? '';
    final String phone = prefs.getString(Common.mobileNumber) ?? '';
    final String role = prefs.getString(Common.roleName) ?? '';

    setState(() {
      _fullName = '$firstName $lastName'.trim();
      _email = email;
      _phone = phone;
      _roleName = role;

      _initials = "${firstName.isNotEmpty ? firstName[0] : ''}"
          "${lastName.isNotEmpty ? lastName[0] : ''}".toUpperCase();
    });
  }

  Future<void> _loadTenants() async {
    final prefs = await SharedPreferences.getInstance();

    final tenantsString = prefs.getString(Common.userTenants);
    final savedTenantCode = prefs.getString(Common.selectedTenant);

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

        // 1. Try to load the previously saved tenant first
        if (savedTenantCode != null && savedTenantCode.isNotEmpty) {
          try {
            defaultTenant = tenants.firstWhere((t) =>
            (t['tenantCode'] ?? '').toString().trim().toUpperCase() == savedTenantCode.trim().toUpperCase()
            );
          } catch (_) {}
        }

        // 2. Fallback to default
        if (defaultTenant == null) {
          for (var t in tenants) {
            if (t['isDefault'] == true) {
              defaultTenant = t;
              break;
            }
          }
        }

        // 3. Fallback to first
        if (defaultTenant == null && tenants.isNotEmpty) {
          defaultTenant = tenants.first;
        }

        setState(() {
          _tenants = tenants;
          _selectedTenant = defaultTenant;
          _isLoadingTenants = false;
        });

        // Ensure the pref is up to date with initial selection
        if (_selectedTenant != null) {
          await prefs.setString(Common.selectedTenant, _selectedTenant!['tenantCode']);
        }
      } catch (e) {
        debugPrint("Error parsing tenants: $e");
        setState(() => _isLoadingTenants = false);
      }
    } else {
      setState(() => _isLoadingTenants = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: widget.onBackPressed, // Fixed Back Navigation
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF1C6DD0)),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "My Profile",
              style: TextStyle(
                color: Color(0xFF131754),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top User Info Row ---
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1C6DD0),
                  radius: 24,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fullName.isNotEmpty ? _fullName : 'Unknown User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF131754),
                        ),
                      ),
                      Text(
                        _roleName.isNotEmpty ? 'Lloyds Metals • $_roleName' : 'Lloyds Metals',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // --- Dynamic Tenant Dropdown Badge ---
            _isLoadingTenants
                ? const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FA),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTenant?['tenantCode'],
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF131754)),
                      isDense: true,
                      dropdownColor: Colors.white,
                      onChanged: (String? newTenantCode) async {
                        if (newTenantCode != null) {
                          setState(() {
                            _selectedTenant = _tenants.firstWhere((t) => t['tenantCode'] == newTenantCode);
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(Common.selectedTenant, newTenantCode);
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
            const SizedBox(height: 20),

            // --- Section Title ---
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF131754),
              ),
            ),
            const SizedBox(height: 24),

            // --- Form Fields (Strictly Read-Only) ---
            _buildReadOnlyField(
              label: 'Your Name',
              value: _fullName,
            ),
            const SizedBox(height: 20),
            _buildReadOnlyField(
              label: 'Phone',
              value: _phone,
            ),
            const SizedBox(height: 20),
            _buildReadOnlyField(
              label: 'Email',
              value: _email,
            ),

            const SizedBox(height: 40),

            // --- Change Password Solid Button ---
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C6DD0), // Solid blue background
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Custom widget to display the data in a box that matches the design
  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF131754),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF131754),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// Adjust these import paths to match your project structure
import '../../../utilities/common.dart';
import '../../../view_model/login_view_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  // 🔹 Callbacks removed! We don't need them anymore.
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // User Data Variables
  String _fullName = '';
  String _initials = '';
  String _roleName = '';

  // Controllers
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Visibility States
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final String firstName = prefs.getString(Common.firstName) ?? '';
    final String lastName = prefs.getString(Common.lastName) ?? '';
    final String role = prefs.getString(Common.roleName) ?? '';

    setState(() {
      _fullName = '$firstName $lastName'.trim();
      _roleName = role;
      _initials = "${firstName.isNotEmpty ? firstName[0] : ''}"
          "${lastName.isNotEmpty ? lastName[0] : ''}".toUpperCase();
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword(LoginViewModel viewModel) async {
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all password fields'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New Password and Confirm Password do not match'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    bool success = await viewModel.changePassword(oldPass, newPass, confirmPass);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!'), backgroundColor: Colors.green),
      );
      // 🔹 Just pop context to go back to profile!
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Failed to change password'), backgroundColor: Colors.redAccent),
      );
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
            onTap: () => Navigator.pop(context), // 🔹 Simple Pop Navigation
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
              "Change Password",
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
            const SizedBox(height: 40),

            Text(
              'Change Password',
              style:TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF131754),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please enter your new password',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            _buildPasswordField(
              label: 'Old Password',
              controller: _oldPasswordController,
              isObscure: _obscureOld,
              onToggleVisibility: () {
                setState(() {
                  _obscureOld = !_obscureOld;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              isObscure: _obscureNew,
              onToggleVisibility: () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              isObscure: _obscureConfirm,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
            ),
            const SizedBox(height: 32),

            Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () => _submitChangePassword(viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C6DD0),
                      disabledBackgroundColor: Colors.grey.shade400,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context), // 🔹 Simple Pop Navigation
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF131754),
                ),
                child: Text(
                  'Back to profile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
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
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF131754),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF1C6DD0)),
            ),
            fillColor: Colors.white,
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF131754).withOpacity(0.7),
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
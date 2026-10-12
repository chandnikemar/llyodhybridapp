import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// Adjust these import paths to match your project structure
import '../../../utilities/common_config.dart';
import '../../../view_model/login_view_model.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 1 = Enter Username, 2 = Enter OTP & New Passwords
  int _currentStep = 1;

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State Variables
  bool _isUsernameEmpty = true;
  bool _showUsernameError = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // Listener to dynamically enable/disable the 'Next' button
    _usernameController.addListener(() {
      setState(() {
        _isUsernameEmpty = _usernameController.text.trim().isEmpty;
        if (!_isUsernameEmpty) _showUsernameError = false;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Step 1 Action: Send OTP ---
  Future<void> _handleNext(LoginViewModel viewModel) async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() => _showUsernameError = true);
      return;
    }

    final success = await viewModel.forgotPassword(username);
    if (!mounted) return;

    if (success) {
      setState(() {
        _currentStep = 2; // Move to OTP Screen
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email.'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Failed to send OTP'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // --- Step 2 Action: Reset Password ---
  Future<void> _handleResetPassword(LoginViewModel viewModel) async {
    final username = _usernameController.text.trim();
    final otp = _otpController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (otp.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // 1. Capture the String message instead of a boolean
    final String? successMessage = await viewModel.resetPassword(username, otp, newPass, confirmPass, otp);

    if (!mounted) return;

    // 2. Check if the message is not null
    if (successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // 3. Display the dynamic success message from the API
        SnackBar(content: Text(successMessage), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Go back to login screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Failed to reset password'), backgroundColor: Colors.redAccent),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF4F7FC), // Same as login background
      body: Stack(
        children: [
          // 1. Background Image with Gradient Fade (Matching LoginScreen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.35,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                CommonConfig.loginBg,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 2. Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Consumer<LoginViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Push content down slightly over the background
                      SizedBox(height: screenHeight * 0.15),

                      // --- Titles ---
                      Text(
                        'Forgot your password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF131754),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please enter the User Name associated with your account and We will email you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // --- Dynamic Content based on Step ---
                      if (_currentStep == 1) ...[
                        _buildStep1Username(viewModel),
                      ] else ...[
                        _buildStep2Reset(viewModel),
                      ],

                      // Bottom padding to ensure scrollable area works well with keyboard
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STEP 1 WIDGETS (Username Entry)
  // =========================================================
// =========================================================
  // STEP 1 WIDGETS (Username Entry)
  // =========================================================
  Widget _buildStep1Username(LoginViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel('User Name'),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _showUsernameError ? Colors.redAccent : Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _showUsernameError ? Colors.redAccent : const Color(0xFF1C6DD0)),
            ),
          ),
        ),
        if (_showUsernameError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Username is required.',
              textAlign: TextAlign.right,
              style:TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),

        // 🔹 FIXED: Next Button Colors
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: (_isUsernameEmpty || viewModel.isLoading) ? null : () => _handleNext(viewModel),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C6DD0), // Active color is now Blue
              disabledBackgroundColor: const Color(0xFFEAEAEA), // Remains grey when empty
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
            )
                : Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // Active text is white, disabled text is grey
                color: _isUsernameEmpty ? Colors.grey.shade500 : Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Back to Login Button
        _buildBackToLoginButton(),
      ],
    );
  }

  // =========================================================
  // STEP 2 WIDGETS (OTP & Reset)
  // =========================================================
  Widget _buildStep2Reset(LoginViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel('Enter OTP'),
        _buildTextField(_otpController, false),
        const SizedBox(height: 16),

        _buildLabel('New Password'),
        _buildPasswordField(_newPasswordController, _obscureNew, () {
          setState(() => _obscureNew = !_obscureNew);
        }),
        const SizedBox(height: 16),

        _buildLabel('Confirm Password'),
        _buildPasswordField(_confirmPasswordController, _obscureConfirm, () {
          setState(() => _obscureConfirm = !_obscureConfirm);
        }),
        const SizedBox(height: 24),

        // Reset & Resend Buttons Row
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : () => _handleResetPassword(viewModel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0091FF), // Bright Blue
                    disabledBackgroundColor: Colors.grey.shade400,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: viewModel.isLoading ? null : () => _handleNext(viewModel), // Re-trigger OTP
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Back to Login Button
        _buildBackToLoginButton(),
      ],
    );
  }

  // =========================================================
  // REUSABLE UI COMPONENTS
  // =========================================================

  Widget _buildBackToLoginButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF131754)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Back to Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF131754),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style:TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF131754),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C6DD0)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool isObscure, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1C6DD0)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF131754),
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
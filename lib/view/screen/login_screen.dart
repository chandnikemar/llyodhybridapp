import 'dart:io';import 'dart:math';import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:shared_preferences/shared_preferences.dart'; /* 🔹 ADDED IMPORT */import 'package:ut_lloyd_web_app/view/screen/profile/forget_password.dart';import '../../utilities/common.dart';import '../../utilities/common_config.dart';import '../../utilities/device_config_class.dart';import '../../utilities/dialog_helper.dart';import '../../view_model/login_view_model.dart';class _LoginColors {static const heading = Color(0xFF2E3A4F);static const tagline = Color(0xFF4A5671);static const highlight = Color(0xFFFF6638);static const fieldLabel = Color(0xFF9E9EA1);static const fieldText = Color(0xFF2D3C4C);static const captchaLabel = Color(0xFF132436);static const linkText = Color(0xFF4A4A4D);static const loginButton = Color(0xFF1C6DD0);static const loginButtonDisabled = Color(0xFFB7C6DA);static const fieldBorder = Color(0xFFE1E3E8);static const fieldFill = Color(0xFFF7F8FA);static const captchaBoxFill = Color(0xFFEFF1F4);/* Custom colors for Plant Selection list */static const listBackground = Color(0xFFF4F7FC);static const selectedPlantBg = Color(0xFFEAF0FA);static const selectedPlantText = Color(0xFF131754);static const selectedPlantCheck = Color(0xFF5C6BC0);}class LoginScreen extends StatefulWidget {const LoginScreen({super.key});@override _LoginScreenState createState() => _LoginScreenState();}class _LoginScreenState extends State<LoginScreen> {final _usernameController = TextEditingController();final _passwordController = TextEditingController();final _captchaInputController = TextEditingController();bool _isPasswordVisible = false;bool _rememberMe = false;String _captchaCode = "";/* Multi-tenant state variables */bool _showPlantSelection = false;bool _isDropdownOpen = false;List<dynamic> _userTenants = [];dynamic _selectedTenant;@override void initState() {super.initState();WidgetsBinding.instance.addPostFrameCallback((_) {DeviceConfig.init(context);setState(() {});});checkIpAddress();_generateCaptcha();_usernameController.addListener(() => setState(() {}));_passwordController.addListener(() => setState(() {}));_captchaInputController.addListener(() => setState(() {}));}@override void dispose() {_usernameController.dispose();_passwordController.dispose();_captchaInputController.dispose();super.dispose();}void checkIpAddress() async {String? ipAddress = await getDeviceIPAddress();print("Device IP Address: $ipAddress");}Future<String?> getDeviceIPAddress() async {try {for (var interface in await NetworkInterface.list()) {for (var addr in interface.addresses) {if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {return addr.address;}}}} catch (e) {print("Error getting IP address: $e");}return null;}void _generateCaptcha() {const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';final rand = Random();setState(() {_captchaCode = List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();_captchaInputController.clear();});}bool get _isCaptchaValid => _captchaInputController.text.trim().toUpperCase() == _captchaCode;bool get _isFormFilled => _usernameController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty && _captchaInputController.text.trim().isNotEmpty; // ---------------------------------------------------------------------
  // Handle Login & Tenant Routing
  /* --------------------------------------------------------------------- */
  Future<void> _handleLogin(LoginViewModel loginViewModel) async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      DialogHelper.showErrorDialog(context, CommonConfig.userNamePasswordEmpty);
      return;
    }

    if (!_isCaptchaValid) {
      DialogHelper.showErrorDialog(context, 'Invalid captcha. Please try again.');
      _generateCaptcha();
      return;
    }

    try {
      final success = await loginViewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        List<dynamic> fetchedTenants = loginViewModel.userModel?.userTenants ?? [];

        debugPrint("API Response: $fetchedTenants");

        if (fetchedTenants.isEmpty) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (fetchedTenants.length == 1) {
          _selectedTenant = fetchedTenants[0];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(Common.selectedTenant, _selectedTenant.tenantCode);

          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _userTenants = fetchedTenants;
            _showPlantSelection = true;
          });
        }
      } else {
        /* 🔹 FIX: Wait for the build frame to settle before showing dialog */
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            DialogHelper.showErrorDialog(
              context,
              loginViewModel.errorMessage ?? 'Login failed. Please try again.',
            );
            _generateCaptcha();
          }
        });
      }
    } catch (e) {
      /* 🔹 FIX: Safely handle caught exceptions as well */
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          DialogHelper.showErrorDialog(context, e.toString());
          _generateCaptcha();
        }
      });
    }
  }

  /* 🔹 CHANGED: Made async to handle SharedPreferences */
  Future<void> _handleProceed() async {
    if (_selectedTenant == null) {
      DialogHelper.showErrorDialog(context, 'Please select a plant to proceed.');
      return;
    }

    /* 🔹 ADDED: Save the selected tenant code to SharedPreferences */
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Common.selectedTenant, _selectedTenant!.tenantCode);

    /* Proceed to home with the selected tenant */
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  // ---------------------------------------------------------------------
  // Build Methods
  /* --------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    if (DeviceConfig.screenHeight == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          /* 1. Background Image with Gradient Fade */
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: DeviceConfig.screenHeight! * 0.35,
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

          /* 2. Foreground Form Content */
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 20.0),
                    child: Image.asset(
                      CommonConfig.loginHeader,
                      height: AppSizes.loginFieldHeight(),
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: DeviceConfig.screenHeight! * 0.08),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeading(),
                        const SizedBox(height: 6),
                        _buildTagline(),

                        SizedBox(height: DeviceConfig.screenHeight! * 0.03),

                        /* Render either Plant Selection or Credentials based on state */
                        if (_showPlantSelection)
                          _buildPlantSelector()
                        else _buildCredentialsForm(),

                        const SizedBox(height: 24),
                        _buildPrimaryButton(),
                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            'Powered by Kemar Automation',
                            style: TextStyle(
                              fontSize: AppSizes.fontSmallSize(),
                              color: _LoginColors.fieldLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(CommonConfig.userNameLabel),
        const SizedBox(height: 6),
        _buildUsernameField(),
        const SizedBox(height: 16),

        _buildFieldLabel(CommonConfig.passwordLabel),
        const SizedBox(height: 6),
        _buildPasswordField(),
        const SizedBox(height: 16),

        _buildFieldLabel('Captcha'),
        const SizedBox(height: 6),
        _buildCaptchaRow(),
        const SizedBox(height: 10),
        _buildCaptchaInputField(),
        const SizedBox(height: 16),

        _buildRememberAndForgotRow(),
      ],
    );
  }

  Widget _buildPlantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Select Plant'),
        const SizedBox(height: 6),

        /* Custom Dropdown Header with FIXED sizes */
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            width: 315, /* Fixed width */
            height: 45, /* Fixed height */
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _LoginColors.fieldFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _LoginColors.fieldBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.factory_outlined, color: _LoginColors.fieldLabel, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedTenant != null ? _selectedTenant!.tenantName : '-- Select Plant --',
                    style: TextStyle(
                      color: _selectedTenant != null ? _LoginColors.fieldText : _LoginColors.fieldLabel,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                    _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: _LoginColors.fieldLabel
                ),
              ],
            ),
          ),
        ),

        /* Expanded Dropdown List - SCROLLABLE with Max Height */
        if (_isDropdownOpen)
          Container(
            width: 315,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: _LoginColors.listBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(
              maxHeight: 220,
            ),
            child: RawScrollbar(
              thumbVisibility: true,
              thumbColor: _LoginColors.fieldLabel.withOpacity(0.5),
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: _userTenants.map((tenant) {
                      bool isSelected = _selectedTenant != null && _selectedTenant!.tenantCode == tenant.tenantCode;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTenant = tenant;
                            _isDropdownOpen = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? _LoginColors.selectedPlantBg : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  tenant.tenantName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? _LoginColors.selectedPlantText : _LoginColors.fieldLabel,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: _LoginColors.selectedPlantCheck, size: 20),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeading() {
    return Text(
      _showPlantSelection ? 'Select the Plant' : 'Sign in to continue',
      style: TextStyle(
        fontSize: AppSizes.fontHeaderSize(),
        fontWeight: FontWeight.w600,
        color: _LoginColors.heading,
      ),
    );
  }

  Widget _buildTagline() {
    return RichText(
      text: TextSpan(
        style:TextStyle(
          fontSize: AppSizes.fontSize(),
          fontWeight: FontWeight.bold,
          color: _LoginColors.tagline,
        ),
        children: [
          const TextSpan(text: 'Connecting the '),
          TextSpan(
            text: 'Logistic',
            style: TextStyle(color: _LoginColors.highlight),
          ),
          const TextSpan(text: ' Supply Chain'),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: AppSizes.fontSize(),
        fontWeight: FontWeight.w600,
        color: _LoginColors.fieldLabel,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: _LoginColors.fieldLabel,
        fontSize: AppSizes.fontSize(),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _LoginColors.fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _LoginColors.fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _LoginColors.heading, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _LoginColors.fieldBorder),
      ),
    );
  }

  Widget _buildUsernameField() {
    return SizedBox(
      width: AppSizes.loginFieldWidth(context),
      height: AppSizes.loginFieldHeight(),
      child: TextField(
        controller: _usernameController,
        style:TextStyle(
          color: _LoginColors.fieldText,
          fontSize: AppSizes.fontSize(),
          fontWeight: FontWeight.w600,
        ),
        cursorColor: _LoginColors.fieldText,
        decoration: _fieldDecoration(
          hint: 'Enter username',
          prefixIcon: Icon(
            Icons.person_outline,
            color: _LoginColors.fieldLabel,
            size: AppSizes.fontSize() + 4,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      width: AppSizes.loginFieldWidth(context),
      height: AppSizes.loginFieldHeight(),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          color: _LoginColors.fieldText,
          fontSize: AppSizes.fontSize(),
          fontWeight: FontWeight.w600,
        ),
        cursorColor: _LoginColors.fieldText,
        decoration: _fieldDecoration(
          hint: CommonConfig.passwordHint,
          prefixIcon: Icon(
            Icons.key_outlined,
            color: _LoginColors.fieldLabel,
            size: AppSizes.fontSize() + 4,
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: _LoginColors.fieldLabel,
              size: AppSizes.fontSize() + 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptchaRow() {
    double totalWidth = AppSizes.loginFieldWidth(context);
    double refreshBtnSize = AppSizes.loginFieldHeight();
    double spacing = 8.0;
    double boxWidth = totalWidth - refreshBtnSize - spacing;

    return Row(
      children: [
        Container(
          width: boxWidth,
          height: AppSizes.loginFieldHeight(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _LoginColors.captchaBoxFill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _LoginColors.fieldBorder),
          ),
          child: Text(
            _captchaCode.split('').join(' '),
            style: TextStyle(
              fontSize: AppSizes.fontSize(),
              fontWeight: FontWeight.bold,
              color: _LoginColors.captchaLabel,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(width: spacing),
        InkWell(
          onTap: _generateCaptcha,
          child: Container(
            width: refreshBtnSize,
            height: refreshBtnSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _LoginColors.fieldFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _LoginColors.fieldBorder),
            ),
            child: Icon(
              Icons.refresh,
              color: _LoginColors.captchaLabel,
              size: AppSizes.fontSize() + 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptchaInputField() {
    return SizedBox(
      width: AppSizes.loginFieldWidth(context),
      height: AppSizes.loginFieldHeight(),
      child: TextField(
        controller: _captchaInputController,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(
          color: _LoginColors.fieldText,
          fontSize: AppSizes.fontSize(),
          fontWeight: FontWeight.w600,
        ),
        cursorColor: _LoginColors.fieldText,
        decoration: _fieldDecoration(hint: 'Enter Captcha'),
      ),
    );
  }

  Widget _buildRememberAndForgotRow() {
    return SizedBox(
      width: AppSizes.loginFieldWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: _LoginColors.loginButton,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Remember Me',
                style: TextStyle(
                  fontSize: AppSizes.fontSize(),
                  fontWeight: FontWeight.w500,
                  color: _LoginColors.linkText,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: AppSizes.fontSize(),
                fontWeight: FontWeight.w500,
                color: _LoginColors.loginButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        if (loginViewModel.isLoading) {
          return SizedBox(
            width: AppSizes.loginFieldWidth(context),
            height: AppSizes.loginButtonHeight(),
            child: const Center(
              child: CircularProgressIndicator(color: _LoginColors.loginButton),
            ),
          );
        }

        final bool isEnabled = _showPlantSelection ? true : _isFormFilled;

        return SizedBox(
          width: AppSizes.loginFieldWidth(context),
          height: AppSizes.loginButtonHeight(),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () { _showPlantSelection ? _handleProceed() : _handleLogin(loginViewModel); }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _LoginColors.loginButton,
              disabledBackgroundColor: _LoginColors.loginButtonDisabled,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              _showPlantSelection ? 'Proceed' : CommonConfig.loginSubmit,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.buttonFontSize(),
              ),
            ),
          ),
        );
      },
    );
  }
}
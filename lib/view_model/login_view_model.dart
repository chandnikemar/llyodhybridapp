import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login/authenticate_response.dart';
import '../service/api_service.dart';
import '../utilities/common.dart';

class LoginViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  bool _isLoading = false;
  String? _errorMessage;

  // 1. Create a variable to hold the parsed response
  AuthenticateResponse? _userModel;

  // Create a variable to hold the explicitly selected tenant
  String? _selectedTenant;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // 2. Expose public getters for the UI to use
  AuthenticateResponse? get userModel => _userModel;

  String? get selectedTenant => _selectedTenant;

  Future<bool> login(
    String username,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _userModel = null;

    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      if (response != null) {
        final authResponse = AuthenticateResponse.fromJson(response.data);

        // 3. Assign the parsed response to our ViewModel variable
        _userModel = authResponse;

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(Common.userName, authResponse.userName);
        await prefs.setString(Common.firstName, authResponse.firstName);
        await prefs.setString(Common.lastName, authResponse.lastName);
        await prefs.setString(Common.email, authResponse.email);
        await prefs.setString(Common.mobileNumber, authResponse.mobileNumber);
        await prefs.setString(Common.roleName, authResponse.roleName);
        await prefs.setBool(Common.isVerified, authResponse.isVerified);
        await prefs.setString(Common.jwtToken, authResponse.jwtToken);
        await prefs.setString(Common.refreshToken, authResponse.refreshToken);

        // 🔹 LOG: Print authenticate API tokens
        print('🔑 [Authenticate API] JWT Token: ${authResponse.jwtToken.substring(0, 20)}...');
        print('🔑 [Authenticate API] Refresh Token: ${authResponse.refreshToken.substring(0, 20)}...');
        print('🔑 [Authenticate API] Number of tenants: ${authResponse.userTenants.length}');

        // New fields
        await prefs.setString(Common.tenantGroup, authResponse.tenantGroup);

        await prefs.setString(
            Common.defaultTenantCode, authResponse.defaultTenantCode);

        // --- REMOVED: Don't set selectedTenant here ---
        // selectedTenant will be set by switchTenant API for both single and multiple tenants

        await prefs.setString(Common.bpCode, authResponse.bpCode ?? '');

        // Store complete objects as JSON
        await prefs.setString(
            Common.userAccess,
            jsonEncode(
                authResponse.userAccess.map((e) => e.toJson()).toList()));

        await prefs.setString(
            Common.menuAccess,
            jsonEncode(
                authResponse.menuAccess.map((e) => e.toJson()).toList()));

        await prefs.setString(
            Common.userTenants,
            jsonEncode(
                authResponse.userTenants.map((e) => e.toJson()).toList()));

        await prefs.setBool(Common.isLoggedIn, true);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // NEW: CHANGE PASSWORD LOGIC
  // ==========================================
  Future<bool> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Get the saved username from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String username = prefs.getString(Common.userName) ?? '';

      if (username.isEmpty) {
        throw Exception("User session expired. Please log in again.");
      }

      // 2. Call the API Service
      // Make sure your ApiService contains the changePassword method you provided
      final response = await _apiService.changePassword(
        username,
        newPassword,
        oldPassword,
        confirmPassword,
      );

      // 3. Handle the response
      if (response != null) {
        // Checking for a standard success status code (200 OK)
        if (response.statusCode == 200 || response.statusCode == 201) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          // If API returns 200 but contains a logical error in the body, adjust this
          throw Exception(
              response.data['message'] ?? "Failed to change password");
        }
      } else {
        // If your handleDioException returns a String error message
        if (response is String) {
          throw Exception(response);
        }
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String userName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (userName.isEmpty) {
        throw Exception("Please enter user name.");
      }
      final response = await _apiService.forgotPassword(userName);

      // 3. Handle the response
      if (response != null) {
        // Checking for a standard success status code (200 OK)
        if (response.statusCode == 200 || response.statusCode == 201) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          // If API returns 200 but contains a logical error in the body, adjust this
          throw Exception(
              response.data['message'] ?? "Failed to change password");
        }
      } else {
        // If your handleDioException returns a String error message
        if (response is String) {
          throw Exception(response);
        }
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> resetPassword(String username, String otp, String password,
      String confirmPassword, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty) {
        throw Exception("Please enter user name.");
      }
      final response = await _apiService.resetPassword(username, otp, password, confirmPassword, token);

      // Handle the response
      if (response != null) {
        // Checking for a standard success status code (200 OK)
        if (response.statusCode == 200 || response.statusCode == 201) {
          _isLoading = false;
          notifyListeners();

          // 🔹 RETURN THE MESSAGE FROM THE API
          return response.data['message'] ?? "Your password has been reset";
        } else {
          // If API returns an error in the body
          throw Exception(response.data['message'] ?? "Failed to change password");
        }
      } else {
        // If your handleDioException returns a String error message
        if (response is String) {
          throw Exception(response);
        }
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();

      // 🔹 RETURN NULL ON FAILURE
      return null;
    }
  }

  // ==========================================
  // SWITCH TENANT LOGIC
  // ==========================================
  Future<bool> switchTenant(String tenantCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get the current REFRESH TOKEN from authenticate API
      final prefs = await SharedPreferences.getInstance();
      final currentRefreshToken = prefs.getString(Common.refreshToken);

      if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
        throw Exception("Session expired. Please log in again.");
      }

      print('🔑 [SwitchTenant ViewModel] Current refreshToken from authenticate API: ${currentRefreshToken.substring(0, 20)}...');

      // Call switchTenant API with refreshToken
      final response = await _apiService.switchTenant(tenantCode, currentRefreshToken);

      if (response != null) {
        final switchResponse = AuthenticateResponse.fromJson(response.data);

        // 🔹 LOG: Print switchTenant API tokens
        print('🔑 [SwitchTenant ViewModel] New jwtToken from switchTenant API: ${switchResponse.jwtToken.substring(0, 20)}...');
        print('🔑 [SwitchTenant ViewModel] New refreshToken from switchTenant API: ${switchResponse.refreshToken.substring(0, 20)}...');

        // Update stored tokens and user data with switchTenant response
        await prefs.setString(Common.userName, switchResponse.userName);
        await prefs.setString(Common.firstName, switchResponse.firstName);
        await prefs.setString(Common.lastName, switchResponse.lastName);
        await prefs.setString(Common.email, switchResponse.email);
        await prefs.setString(Common.mobileNumber, switchResponse.mobileNumber);
        await prefs.setString(Common.roleName, switchResponse.roleName);
        await prefs.setBool(Common.isVerified, switchResponse.isVerified);

        // 🔹 IMPORTANT: Update JWT token and refresh token with switchTenant response
        await prefs.setString(Common.jwtToken, switchResponse.jwtToken);
        await prefs.setString(Common.refreshToken, switchResponse.refreshToken);

        // Update other fields
        await prefs.setString(Common.tenantGroup, switchResponse.tenantGroup);
        await prefs.setString(Common.defaultTenantCode, switchResponse.defaultTenantCode);
        await prefs.setString(Common.selectedTenant, tenantCode);
        await prefs.setString(Common.bpCode, switchResponse.bpCode ?? '');

        // Update access and menu permissions
        await prefs.setString(
            Common.userAccess,
            jsonEncode(
                switchResponse.userAccess.map((e) => e.toJson()).toList()));

        await prefs.setString(
            Common.menuAccess,
            jsonEncode(
                switchResponse.menuAccess.map((e) => e.toJson()).toList()));

        // 🔹 IMPORTANT: Do NOT update userTenants from switchTenant response
        // Keep the original tenant list from authenticate API
        // This ensures the dropdown list remains unchanged

        print('🔑 [SwitchTenant ViewModel] Tokens updated successfully for tenant: $tenantCode');

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

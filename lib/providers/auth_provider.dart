import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _token != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _token = response.data!.token;

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> tryAutoLogin() async {
    _isInitializing = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('auth_token')) {
        _isInitializing = false;
        notifyListeners();
        return;
      }

      final savedToken = prefs.getString('auth_token');
      if (savedToken != null) {
        _token = savedToken;
        // Fetch latest profile to verify token and get user data
        final success = await fetchUserProfile();
        if (!success) {
          // If profile fetch fails (e.g., token expired), clear everything
          await logout();
        }
      }
    } catch (e) {
      debugPrint('Auto login error: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    if (_token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Call the API
      await _authService.logout(_token!);

      // Clear local data always
      _user = null;
      _token = null;
      _errorMessage = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Clean up state even on error
      _user = null;
      _token = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchUserProfile() async {
    if (_token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.getMe(_token!);

      if (response.success && response.data != null) {
        _user = response.data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat mengambil profil';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (_token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.updateProfile(
        _token!,
        name: name,
        phone: phone,
      );

      if (response.success && response.data != null) {
        _user = response.data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memperbarui profil';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (_token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.updatePassword(
        _token!,
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      _isLoading = false;
      if (response.success) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memperbarui password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

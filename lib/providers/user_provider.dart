import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  Meta? _meta;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Meta? get meta => _meta;

  Future<bool> fetchUsers(
    String token, {
    String? search,
    String? role,
    int? partnerId,
    bool? isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.getUsers(
        token,
        search: search,
        role: role,
        partnerId: partnerId,
        isActive: isActive,
      );

      if (response.success && response.data != null) {
        _users = response.data!;
        _meta = response.meta;
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
      _errorMessage = 'Terjadi kesalahan saat mengambil list user';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addUser(String token, Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.createUser(token, userData);

      if (response.success && response.data != null) {
        _users.insert(0, response.data!);
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
      _errorMessage = 'Terjadi kesalahan saat menambah user';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(
    String token,
    int id,
    Map<String, dynamic> userData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.updateUser(token, id, userData);

      if (response.success && response.data != null) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = response.data!;
        }
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
      _errorMessage = 'Terjadi kesalahan saat memperbarui user';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.deleteUser(token, id);

      if (response.success) {
        _users.removeWhere((u) => u.id == id);
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
      _errorMessage = 'Terjadi kesalahan saat menghapus user';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

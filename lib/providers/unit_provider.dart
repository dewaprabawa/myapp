import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../services/unit_service.dart';

class UnitProvider with ChangeNotifier {
  final UnitService _unitService = UnitService();
  List<UnitData> _units = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UnitData> get units => _units;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUnits(
    String token, {
    String? search,
    bool? isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _unitService.getUnits(
      token,
      search: search,
      isActive: isActive,
    );

    if (response.success) {
      _units = response.data;
    } else {
      _errorMessage = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addUnit(String token, UnitData unit) async {
    _isLoading = true;
    notifyListeners();

    final response = await _unitService.createUnit(token, unit);

    if (response.success) {
      _units.insert(0, response.data);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUnit(String token, UnitData unit) async {
    _isLoading = true;
    notifyListeners();

    final response = await _unitService.updateUnit(token, unit);

    if (response.success) {
      final index = _units.indexWhere((element) => element.id == unit.id);
      if (index != -1) {
        _units[index] = response.data;
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
  }

  Future<bool> deleteUnit(String token, int id) async {
    _isLoading = true;
    notifyListeners();

    final response = await _unitService.deleteUnit(token, id);

    if (response['success'] == true) {
      _units.removeWhere((element) => element.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Gagal menghapus satuan';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

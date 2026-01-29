import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<CategoryData> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryData> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories(
    String token, {
    String? search,
    bool? isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _categoryService.getCategories(
      token,
      search: search,
      isActive: isActive,
    );

    if (response.success) {
      _categories = response.data;
    } else {
      _errorMessage = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCategory(String token, CategoryData category) async {
    _isLoading = true;
    notifyListeners();

    final response = await _categoryService.createCategory(token, category);

    if (response.success) {
      _categories.insert(0, response.data);
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

  Future<bool> updateCategory(String token, CategoryData category) async {
    _isLoading = true;
    notifyListeners();

    final response = await _categoryService.updateCategory(token, category);

    if (response.success) {
      final index = _categories.indexWhere(
        (element) => element.id == category.id,
      );
      if (index != -1) {
        _categories[index] = response.data;
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

  Future<bool> deleteCategory(String token, int id) async {
    _isLoading = true;
    notifyListeners();

    final response = await _categoryService.deleteCategory(token, id);

    if (response['success'] == true) {
      _categories.removeWhere((element) => element.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Gagal menghapus kategori';
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

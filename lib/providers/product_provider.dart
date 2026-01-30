import 'package:flutter/material.dart';
import 'package:myapp/models/pagination_model.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();
  List<ProductData> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<ProductData> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchProducts(
    String token, {
    bool loadMore = false,
    String? search,
    int? categoryId,
    bool? isActive,
    int perPage = 15,
  }) async {
    if (loadMore && (_meta == null || _meta!.currentPage >= _meta!.lastPage))
      return;

    _isLoading = true;
    if (!loadMore) {
      _products = [];
      _meta = null;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_meta?.currentPage ?? 0) + 1 : 1;
      final response = await _service.getProducts(
        token,
        search: search,
        categoryId: categoryId,
        isActive: isActive,
        perPage: perPage,
        page: nextPage,
      );

      if (loadMore) {
        _products.addAll(response.data);
      } else {
        _products = response.data;
      }
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(String token, ProductData product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.storeProduct(token, product);
      await fetchProducts(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(String token, ProductData product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updateProduct(token, product);
      await fetchProducts(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteProduct(token, id);
      await fetchProducts(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProductData?> fetchProductDetail(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getProductDetail(token, id);
      return response.data;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

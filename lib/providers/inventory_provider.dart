import 'package:flutter/material.dart';
import 'package:myapp/models/inventory_model.dart';
import 'package:myapp/models/pagination_model.dart';
import 'package:myapp/services/inventory_service.dart';

class InventoryProvider with ChangeNotifier {
  final InventoryService _service = InventoryService();
  List<InventoryData> _inventories = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<InventoryData> get inventories => _inventories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchInventories(
    String token, {
    String? search,
    int? categoryId,
    bool? lowStock,
    int perPage = 15,
    int page = 1,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getInventories(
        token,
        search: search,
        categoryId: categoryId,
        lowStock: lowStock,
        perPage: perPage,
        page: page,
      );
      _inventories = response.data;
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPartnerInventory(
    String token,
    int partnerId, {
    String? search,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getPartnerInventory(
        token,
        partnerId,
        search: search,
      );
      _inventories = response.data;
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<InventoryData?> fetchInventoryDetail(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final detail = await _service.getInventoryDetail(token, id);
      return detail;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

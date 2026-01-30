import 'package:flutter/material.dart';
import 'package:myapp/models/pagination_model.dart';
import 'package:myapp/models/stock_opname_model.dart';
import 'package:myapp/services/stock_opname_service.dart';

class StockOpnameProvider with ChangeNotifier {
  final StockOpnameService _service = StockOpnameService();
  List<StockOpnameData> _stockOpnames = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<StockOpnameData> get stockOpnames => _stockOpnames;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchStockOpnames(
    String token, {
    bool loadMore = false,
    String? search,
    int? partnerId,
    String? status,
    int perPage = 15,
  }) async {
    if (loadMore && (_meta == null || _meta!.currentPage >= _meta!.lastPage))
      return;

    _isLoading = true;
    if (!loadMore) {
      _stockOpnames = [];
      _meta = null;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_meta?.currentPage ?? 0) + 1 : 1;
      final response = await _service.getStockOpnames(
        token,
        search: search,
        partnerId: partnerId,
        status: status,
        perPage: perPage,
        page: nextPage,
      );

      if (loadMore) {
        _stockOpnames.addAll(response.data);
      } else {
        _stockOpnames = response.data;
      }
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<StockOpnameData?> fetchStockOpnameDetail(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _service.getStockOpnameDetail(token, id);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createStockOpname(
    String token,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.createStockOpname(token, data);
      await fetchStockOpnames(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitStockOpname(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.submitStockOpname(token, id);
      await fetchStockOpnames(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> approveStockOpname(String token, int id, {String? notes}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.approveStockOpname(token, id, notes: notes);
      await fetchStockOpnames(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> rejectStockOpname(String token, int id, String reason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.rejectStockOpname(token, id, reason);
      await fetchStockOpnames(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

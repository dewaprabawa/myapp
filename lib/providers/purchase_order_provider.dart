import 'package:flutter/material.dart';
import 'package:distributorsfast/models/pagination_model.dart';
import 'package:distributorsfast/models/purchase_order_model.dart';
import 'package:distributorsfast/services/purchase_order_service.dart';

class PurchaseOrderProvider with ChangeNotifier {
  final PurchaseOrderService _service = PurchaseOrderService();
  List<PurchaseOrderData> _purchaseOrders = [];
  List<PurchaseOrderSummaryData> _poSummary = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<PurchaseOrderData> get purchaseOrders => _purchaseOrders;
  List<PurchaseOrderSummaryData> get poSummary => _poSummary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchPurchaseOrders(
    String token, {
    bool loadMore = false,
    String? search,
    int? partnerId,
    String? status,
    String? startDate,
    String? endDate,
    int perPage = 15,
  }) async {
    if (loadMore && (_meta == null || _meta!.currentPage >= _meta!.lastPage))
      return;

    _isLoading = true;
    if (!loadMore) {
      _purchaseOrders = [];
      _meta = null;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_meta?.currentPage ?? 0) + 1 : 1;
      final response = await _service.getPurchaseOrders(
        token,
        search: search,
        partnerId: partnerId,
        status: status,
        startDate: startDate,
        endDate: endDate,
        perPage: perPage,
        page: nextPage,
      );

      if (loadMore) {
        _purchaseOrders.addAll(response.data);
      } else {
        _purchaseOrders = response.data;
      }
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PurchaseOrderData?> fetchPurchaseOrderDetail(
    String token,
    int id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getPurchaseOrder(token, id);
      return response.data;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitPO(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.submitPurchaseOrder(token, id);
      await fetchPurchaseOrders(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> approvePO(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.approvePurchaseOrder(token, id);
      await fetchPurchaseOrders(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPOSummary(
    String token, {
    required String startDate,
    required String endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getPurchaseOrderSummary(
        token,
        startDate: startDate,
        endDate: endDate,
      );
      _poSummary = response.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

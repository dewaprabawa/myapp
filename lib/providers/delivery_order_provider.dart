import 'package:flutter/material.dart';
import 'package:myapp/models/delivery_order_model.dart';
import 'package:myapp/models/pagination_model.dart';
import 'package:myapp/services/delivery_order_service.dart';

class DeliveryOrderProvider with ChangeNotifier {
  final DeliveryOrderService _service = DeliveryOrderService();
  List<DeliveryOrderData> _deliveryOrders = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<DeliveryOrderData> get deliveryOrders => _deliveryOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchDeliveryOrders(
    String token, {
    String? search,
    int? partnerId,
    String? status,
    int perPage = 15,
    int page = 1,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getDeliveryOrders(
        token,
        search: search,
        partnerId: partnerId,
        status: status,
        perPage: perPage,
        page: page,
      );
      _deliveryOrders = response.data;
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<DeliveryOrderData?> fetchDeliveryOrderDetail(
    String token,
    int id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _service.getDeliveryOrderDetail(token, id);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDeliveryOrder(
    String token,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.createDeliveryOrder(token, data);
      await fetchDeliveryOrders(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitDeliveryOrder(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.submitDeliveryOrder(token, id);
      await fetchDeliveryOrders(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmDeliveryOrder(
    String token,
    int id,
    Map<String, dynamic> confirmationData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.confirmDeliveryOrder(token, id, confirmationData);
      await fetchDeliveryOrders(token);
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

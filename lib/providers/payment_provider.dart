import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../models/pagination_model.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  List<PaymentData> _payments = [];
  PaginationMeta? _meta;
  bool _isLoading = false;
  String? _error;

  List<PaymentData> get payments => _payments;
  PaginationMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPayments({
    bool loadMore = false,
    int perPage = 15,
    String? search,
    int? partnerId,
    int? invoiceId,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (loadMore && (_meta == null || _meta!.currentPage >= _meta!.lastPage))
      return;

    _isLoading = true;
    if (!loadMore) {
      _payments = [];
      _meta = null;
    }
    _error = null;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_meta?.currentPage ?? 0) + 1 : 1;
      final response = await _paymentService.getPayments(
        page: nextPage,
        perPage: perPage,
        search: search,
        partnerId: partnerId,
        invoiceId: invoiceId,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );

      if (loadMore) {
        _payments.addAll(response.data);
      } else {
        _payments = response.data;
      }
      _meta = response.meta;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentData?> getPaymentDetail(int id) async {
    try {
      return await _paymentService.getPaymentDetail(id);
    } catch (e) {
      print("Error fetching payment detail: $e");
      return null;
    }
  }

  Future<bool> approvePayment(int id) async {
    try {
      return await _paymentService.approvePayment(id);
    } catch (e) {
      print("Error approving payment: $e");
      return false;
    }
  }

  Future<bool> rejectPayment(int id, String reason) async {
    try {
      return await _paymentService.rejectPayment(id, reason);
    } catch (e) {
      print("Error rejecting payment: $e");
      return false;
    }
  }
}

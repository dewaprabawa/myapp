import 'package:flutter/material.dart';
import '../models/invoice_model.dart';
import '../models/pagination_model.dart';
import '../services/invoice_service.dart';

class InvoiceProvider with ChangeNotifier {
  final InvoiceService _invoiceService = InvoiceService();

  List<InvoiceData> _invoices = [];
  PaginationMeta? _meta;
  bool _isLoading = false;
  String? _error;

  List<InvoiceData> get invoices => _invoices;
  PaginationMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchInvoices({
    bool loadMore = false,
    int perPage = 15,
    String? search,
    int? partnerId,
    String? status,
    String? startDate,
    String? endDate,
    bool? overdue,
  }) async {
    if (loadMore && (_meta == null || _meta!.currentPage >= _meta!.lastPage))
      return;

    _isLoading = true;
    if (!loadMore) {
      _invoices = [];
      _meta = null;
    }
    _error = null;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_meta?.currentPage ?? 0) + 1 : 1;
      final response = await _invoiceService.getInvoices(
        page: nextPage,
        perPage: perPage,
        search: search,
        partnerId: partnerId,
        status: status,
        startDate: startDate,
        endDate: endDate,
        overdue: overdue,
      );

      if (loadMore) {
        _invoices.addAll(response.data);
      } else {
        _invoices = response.data;
      }
      _meta = response.meta;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<InvoiceData?> getInvoiceDetail(int id) async {
    try {
      return await _invoiceService.getInvoiceDetail(id);
    } catch (e) {
      print("Error fetching invoice detail: $e");
      return null;
    }
  }

  Future<bool> cancelInvoice(int id) async {
    try {
      return await _invoiceService.cancelInvoice(id);
    } catch (e) {
      print("Error cancelling invoice: $e");
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  SalesReportData? _salesReport;
  AgingReportData? _agingReport;
  InventoryReportData? _inventoryReport;

  bool _isLoading = false;
  String? _error;

  SalesReportData? get salesReport => _salesReport;
  AgingReportData? get agingReport => _agingReport;
  InventoryReportData? get inventoryReport => _inventoryReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSalesReport({
    String? startDate,
    String? endDate,
    int? partnerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _salesReport = await _reportService.getSalesReport(
        startDate: startDate,
        endDate: endDate,
        partnerId: partnerId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAgingReport({int? partnerId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _agingReport = await _reportService.getAgingReport(partnerId: partnerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInventoryReport({
    String type = 'central',
    int? partnerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _inventoryReport = await _reportService.getInventoryReport(
        type: type,
        partnerId: partnerId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

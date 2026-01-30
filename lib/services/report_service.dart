import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_model.dart';

class ReportService {
  final String baseUrl = "https://im.cekweb.cloud/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<SalesReportData> getSalesReport({
    String? startDate,
    String? endDate,
    int? partnerId,
  }) async {
    final token = await _getToken();
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (partnerId != null) queryParams['partner_id'] = partnerId.toString();

    final response = await http.get(
      Uri.parse("$baseUrl/reports/sales").replace(queryParameters: queryParams),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return SalesReportData.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load sales report');
    }
  }

  Future<AgingReportData> getAgingReport({int? partnerId}) async {
    final token = await _getToken();
    final queryParams = <String, String>{};
    if (partnerId != null) queryParams['partner_id'] = partnerId.toString();

    final response = await http.get(
      Uri.parse("$baseUrl/reports/aging").replace(queryParameters: queryParams),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return AgingReportData.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load aging report');
    }
  }

  Future<InventoryReportData> getInventoryReport({
    String type = 'central',
    int? partnerId,
  }) async {
    final token = await _getToken();
    final queryParams = <String, String>{'type': type};
    if (partnerId != null) queryParams['partner_id'] = partnerId.toString();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/reports/inventory",
      ).replace(queryParameters: queryParams),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return InventoryReportData.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load inventory report');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invoice_model.dart';

class InvoiceService {
  final String baseUrl = "https://im.cekweb.cloud/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<InvoiceResponse> getInvoices({
    int page = 1,
    int perPage = 15,
    String? search,
    int? partnerId,
    String? status,
    String? startDate,
    String? endDate,
    bool? overdue,
  }) async {
    final token = await _getToken();

    // Construct query parameters
    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (partnerId != null) queryParams['partner_id'] = partnerId.toString();
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (overdue != null) queryParams['overdue'] = overdue.toString();

    final response = await http.get(
      Uri.parse("$baseUrl/invoices").replace(queryParameters: queryParams),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return InvoiceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  Future<InvoiceData> getInvoiceDetail(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/invoices/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return InvoiceData.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load invoice detail');
    }
  }

  Future<bool> cancelInvoice(int id) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/invoices/$id/cancel"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }
}

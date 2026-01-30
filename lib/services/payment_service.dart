import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_model.dart';

class PaymentService {
  final String baseUrl = "https://im.cekweb.cloud/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<PaymentResponse> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
    int? partnerId,
    int? invoiceId,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    final token = await _getToken();

    // Construct query parameters
    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (partnerId != null) queryParams['partner_id'] = partnerId.toString();
    if (invoiceId != null) queryParams['invoice_id'] = invoiceId.toString();
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    final response = await http.get(
      Uri.parse("$baseUrl/payments").replace(queryParameters: queryParams),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PaymentResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<PaymentData> getPaymentDetail(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/payments/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return PaymentData.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to load payment detail');
    }
  }

  Future<bool> approvePayment(int id) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/payments/$id/approve"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }

  Future<bool> rejectPayment(int id, String reason) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/payments/$id/reject"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'reason': reason}),
    );

    return response.statusCode == 200;
  }
}

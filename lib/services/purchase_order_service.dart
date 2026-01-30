import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:distributorsfast/models/purchase_order_model.dart';

class PurchaseOrderService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<PurchaseOrderResponse> getPurchaseOrders(
    String token, {
    String? search,
    int? partnerId,
    String? status,
    String? startDate,
    String? endDate,
    int perPage = 15,
    int page = 1,
  }) async {
    final queryParams = {
      if (search != null) 'search': search,
      if (partnerId != null) 'partner_id': partnerId.toString(),
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      'per_page': perPage.toString(),
      'page': page.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/purchase-orders',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PurchaseOrderResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load purchase orders: ${response.body}');
    }
  }

  Future<PurchaseOrderSingleResponse> getPurchaseOrder(
    String token,
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchase-orders/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PurchaseOrderSingleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load purchase order detail: ${response.body}');
    }
  }

  Future<void> submitPurchaseOrder(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/purchase-orders/$id/submit'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit purchase order: ${response.body}');
    }
  }

  Future<void> approvePurchaseOrder(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/purchase-orders/$id/approve'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve purchase order: ${response.body}');
    }
  }

  Future<PurchaseOrderSummaryResponse> getPurchaseOrderSummary(
    String token, {
    required String startDate,
    required String endDate,
  }) async {
    final queryParams = {'start_date': startDate, 'end_date': endDate};

    final uri = Uri.parse(
      '$baseUrl/purchase-orders/summary',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PurchaseOrderSummaryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load purchase order summary: ${response.body}',
      );
    }
  }
}

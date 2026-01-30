import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/delivery_order_model.dart';

class DeliveryOrderService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<DeliveryOrderResponse> getDeliveryOrders(
    String token, {
    String? search,
    int? partnerId,
    String? status,
    int perPage = 15,
    int page = 1,
  }) async {
    final queryParams = {
      if (search != null) 'search': search,
      if (partnerId != null) 'partner_id': partnerId.toString(),
      if (status != null) 'status': status,
      'per_page': perPage.toString(),
      'page': page.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/delivery-orders',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return DeliveryOrderResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load delivery orders: ${response.body}');
    }
  }

  Future<DeliveryOrderData> getDeliveryOrderDetail(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/delivery-orders/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return DeliveryOrderData.fromJson(data);
    } else {
      throw Exception('Failed to load delivery order detail: ${response.body}');
    }
  }

  Future<DeliveryOrderData> createDeliveryOrder(
    String token,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delivery-orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final result = json.decode(response.body)['data'];
      return DeliveryOrderData.fromJson(result);
    } else {
      throw Exception('Failed to create delivery order: ${response.body}');
    }
  }

  Future<void> submitDeliveryOrder(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delivery-orders/$id/submit'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit delivery order: ${response.body}');
    }
  }

  Future<void> confirmDeliveryOrder(
    String token,
    int id,
    Map<String, dynamic> confirmationData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delivery-orders/$id/confirm'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(confirmationData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm delivery order: ${response.body}');
    }
  }
}

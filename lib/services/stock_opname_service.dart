import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/stock_opname_model.dart';

class StockOpnameService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<StockOpnameResponse> getStockOpnames(
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
      '$baseUrl/stock-opnames',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StockOpnameResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load stock opnames: ${response.body}');
    }
  }

  Future<StockOpnameData> getStockOpnameDetail(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stock-opnames/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return StockOpnameData.fromJson(data);
    } else {
      throw Exception('Failed to load stock opname detail: ${response.body}');
    }
  }

  Future<StockOpnameData> createStockOpname(
    String token,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stock-opnames'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final result = json.decode(response.body)['data'];
      return StockOpnameData.fromJson(result);
    } else {
      throw Exception('Failed to create stock opname: ${response.body}');
    }
  }

  Future<void> submitStockOpname(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stock-opnames/$id/submit'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit stock opname: ${response.body}');
    }
  }

  Future<void> approveStockOpname(String token, int id, {String? notes}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stock-opnames/$id/approve'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'notes': notes}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve stock opname: ${response.body}');
    }
  }

  Future<void> rejectStockOpname(String token, int id, String reason) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stock-opnames/$id/reject'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'reason': reason}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject stock opname: ${response.body}');
    }
  }
}

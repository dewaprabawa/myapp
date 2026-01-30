import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/inventory_model.dart';

class InventoryService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<InventoryResponse> getInventories(
    String token, {
    String? search,
    int? categoryId,
    bool? lowStock,
    int perPage = 15,
    int page = 1,
  }) async {
    final queryParams = {
      if (search != null) 'search': search,
      if (categoryId != null) 'category_id': categoryId.toString(),
      if (lowStock != null) 'low_stock': lowStock.toString(),
      'per_page': perPage.toString(),
      'page': page.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/inventories',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return InventoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load inventories: ${response.body}');
    }
  }

  Future<InventoryResponse> getPartnerInventory(
    String token,
    int partnerId, {
    String? search,
  }) async {
    final queryParams = {if (search != null) 'search': search};

    final uri = Uri.parse(
      '$baseUrl/inventories/partner/$partnerId',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return InventoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load partner inventory: ${response.body}');
    }
  }

  Future<InventoryData> getInventoryDetail(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventories/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return InventoryData.fromJson(data);
    } else {
      throw Exception('Failed to load inventory detail: ${response.body}');
    }
  }
}

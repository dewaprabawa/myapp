import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/product_model.dart';

class ProductService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<ProductResponse> getProducts(
    String token, {
    String? search,
    int? categoryId,
    bool? isActive,
    int perPage = 15,
  }) async {
    final queryParams = {
      if (search != null) 'search': search,
      if (categoryId != null) 'category_id': categoryId.toString(),
      if (isActive != null) 'is_active': isActive ? '1' : '0',
      'per_page': perPage.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/products',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  Future<ProductData> storeProduct(String token, ProductData product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return ProductData.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<ProductData> updateProduct(String token, ProductData product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductData.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  Future<ProductSingleResponse> getProductDetail(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductSingleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product detail: ${response.body}');
    }
  }
}

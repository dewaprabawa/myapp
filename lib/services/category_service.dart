import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  final String _baseUrl = 'https://im.cekweb.cloud/api';

  Future<CategoryResponse> getCategories(
    String token, {
    String? search,
    bool? isActive,
  }) async {
    try {
      String url = '$_baseUrl/product-categories?';
      if (search != null) url += 'search=$search&';
      if (isActive != null) url += 'is_active=${isActive ? 1 : 0}&';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(data);
      } else {
        return CategoryResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengambil data kategori',
          data: [],
        );
      }
    } catch (e) {
      return CategoryResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: [],
      );
    }
  }

  Future<CategoryDetailResponse> createCategory(
    String token,
    CategoryData category,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/product-categories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category.toJson()),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CategoryDetailResponse.fromJson(data);
      } else {
        return CategoryDetailResponse(
          success: false,
          message: data['message'] ?? 'Gagal membuat kategori',
          data: CategoryData(id: 0, name: '', isActive: false),
        );
      }
    } catch (e) {
      return CategoryDetailResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: CategoryData(id: 0, name: '', isActive: false),
      );
    }
  }

  Future<CategoryDetailResponse> updateCategory(
    String token,
    CategoryData category,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/product-categories/${category.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category.toJson()),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CategoryDetailResponse.fromJson(data);
      } else {
        return CategoryDetailResponse(
          success: false,
          message: data['message'] ?? 'Gagal memperbarui kategori',
          data: CategoryData(id: 0, name: '', isActive: false),
        );
      }
    } catch (e) {
      return CategoryDetailResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: CategoryData(id: 0, name: '', isActive: false),
      );
    }
  }

  Future<Map<String, dynamic>> deleteCategory(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/product-categories/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {"success": false, "message": "Koneksi gagal: $e"};
    }
  }
}

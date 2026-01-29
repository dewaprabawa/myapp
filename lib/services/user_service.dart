import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String _baseUrl = 'https://im.cekweb.cloud/api';

  Future<UserListResponse> getUsers(
    String token, {
    String? search,
    String? role,
    int? partnerId,
    bool? isActive,
    int perPage = 15,
  }) async {
    try {
      final Map<String, String> queryParams = {'per_page': perPage.toString()};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (role != null && role.isNotEmpty) queryParams['role'] = role;
      if (partnerId != null) queryParams['partner_id'] = partnerId.toString();
      if (isActive != null) queryParams['is_active'] = isActive.toString();

      final uri = Uri.parse(
        '$_baseUrl/users',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserListResponse.fromJson(data);
      } else {
        return UserListResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengambil data user',
        );
      }
    } catch (e) {
      return UserListResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<UserResponse> getUserDetails(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(data);
      } else {
        return UserResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengambil detail user',
        );
      }
    } catch (e) {
      return UserResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<UserResponse> createUser(
    String token,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserResponse.fromJson(data);
      } else {
        return UserResponse(
          success: false,
          message: data['message'] ?? 'Gagal menambah user',
        );
      }
    } catch (e) {
      return UserResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<UserResponse> updateUser(
    String token,
    int id,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(data);
      } else {
        return UserResponse(
          success: false,
          message: data['message'] ?? 'Gagal memperbarui user',
        );
      }
    } catch (e) {
      return UserResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<CommonResponse> deleteUser(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(data);
      } else {
        return CommonResponse(
          success: false,
          message: data['message'] ?? 'Gagal menghapus user',
        );
      }
    } catch (e) {
      return CommonResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }
}

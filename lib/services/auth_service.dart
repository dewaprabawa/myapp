import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String _baseUrl = 'https://im.cekweb.cloud/api';

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        return LoginResponse(
          success: false,
          message: data['message'] ?? 'Terjadi kesalahan saat login',
        );
      }
    } catch (e) {
      return LoginResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Add the token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {"success": false, "message": "Koneksi gagal: $e"};
    }
  }

  Future<UserResponse> getMe(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
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
          message: data['message'] ?? 'Gagal mengambil data profil',
        );
      }
    } catch (e) {
      return UserResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<UserResponse> updateProfile(
    String token, {
    required String name,
    required String phone,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'phone': phone}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(data);
      } else {
        return UserResponse(
          success: false,
          message: data['message'] ?? 'Gagal memperbarui profil',
        );
      }
    } catch (e) {
      return UserResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }

  Future<CommonResponse> updatePassword(
    String token, {
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/auth/password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(data);
      } else {
        return CommonResponse(
          success: false,
          message: data['message'] ?? 'Gagal memperbarui password',
        );
      }
    } catch (e) {
      return CommonResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }
}

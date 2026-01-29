import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unit_model.dart';

class UnitService {
  final String _baseUrl = 'https://im.cekweb.cloud/api';

  Future<UnitResponse> getUnits(
    String token, {
    String? search,
    bool? isActive,
  }) async {
    try {
      String url = '$_baseUrl/product-units?';
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
        return UnitResponse.fromJson(data);
      } else {
        return UnitResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengambil data satuan',
          data: [],
        );
      }
    } catch (e) {
      return UnitResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: [],
      );
    }
  }

  Future<UnitDetailResponse> createUnit(String token, UnitData unit) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/product-units'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(unit.toJson()),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return UnitDetailResponse.fromJson(data);
      } else {
        return UnitDetailResponse(
          success: false,
          message: data['message'] ?? 'Gagal membuat satuan',
          data: UnitData(id: 0, name: '', isActive: false),
        );
      }
    } catch (e) {
      return UnitDetailResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: UnitData(id: 0, name: '', isActive: false),
      );
    }
  }

  Future<UnitDetailResponse> updateUnit(String token, UnitData unit) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/product-units/${unit.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(unit.toJson()),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UnitDetailResponse.fromJson(data);
      } else {
        return UnitDetailResponse(
          success: false,
          message: data['message'] ?? 'Gagal memperbarui satuan',
          data: UnitData(id: 0, name: '', isActive: false),
        );
      }
    } catch (e) {
      return UnitDetailResponse(
        success: false,
        message: 'Koneksi gagal: $e',
        data: UnitData(id: 0, name: '', isActive: false),
      );
    }
  }

  Future<Map<String, dynamic>> deleteUnit(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/product-units/$id'),
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

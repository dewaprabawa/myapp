import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class DashboardService {
  final String _baseUrl = 'https://im.cekweb.cloud/api';

  Future<DashboardResponse> getDashboardCentral(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard/central'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(data);
      } else {
        return DashboardResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengambil data dashboard',
        );
      }
    } catch (e) {
      return DashboardResponse(success: false, message: 'Koneksi gagal: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:distributorsfast/models/partner_model.dart';

class PartnerService {
  static const String baseUrl = 'https://im.cekweb.cloud/api';

  Future<PartnerResponse> getPartners(
    String token, {
    String? search,
    bool? isActive,
    int perPage = 15,
  }) async {
    final queryParams = {
      if (search != null) 'search': search,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
      'per_page': perPage.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/partners',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PartnerResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load partners: ${response.body}');
    }
  }

  Future<PartnerData> storePartner(String token, PartnerData partner) async {
    final response = await http.post(
      Uri.parse('$baseUrl/partners'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(partner.toJson()),
    );

    if (response.statusCode == 201) {
      return PartnerData.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create partner: ${response.body}');
    }
  }

  Future<PartnerData> updatePartner(String token, PartnerData partner) async {
    final response = await http.put(
      Uri.parse('$baseUrl/partners/${partner.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(partner.toJson()),
    );

    if (response.statusCode == 200) {
      return PartnerData.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update partner: ${response.body}');
    }
  }

  Future<void> deletePartner(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/partners/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete partner: ${response.body}');
    }
  }

  Future<PartnerSingleResponse> getPartnerDetail(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/partners/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PartnerSingleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load partner detail: ${response.body}');
    }
  }
}

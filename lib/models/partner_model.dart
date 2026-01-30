import 'package:distributorsfast/models/pagination_model.dart';

class PartnerResponse {
  final bool success;
  final List<PartnerData> data;
  final PaginationMeta? meta;

  PartnerResponse({required this.success, required this.data, this.meta});

  factory PartnerResponse.fromJson(Map<String, dynamic> json) {
    return PartnerResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => PartnerData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class PartnerSingleResponse {
  final bool success;
  final PartnerData data;

  PartnerSingleResponse({required this.success, required this.data});

  factory PartnerSingleResponse.fromJson(Map<String, dynamic> json) {
    return PartnerSingleResponse(
      success: json['success'] ?? false,
      data: PartnerData.fromJson(json['data']),
    );
  }
}

class PartnerData {
  final int id;
  final String code;
  final String name;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? phone;
  final String? email;
  final String? npwp;
  final double creditLimit;
  final int paymentTermDays;
  final bool isActive;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PartnerData({
    required this.id,
    required this.code,
    required this.name,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.phone,
    this.email,
    this.npwp,
    required this.creditLimit,
    required this.paymentTermDays,
    required this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory PartnerData.fromJson(Map<String, dynamic> json) {
    return PartnerData(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      email: json['email'],
      npwp: json['npwp'],
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
      paymentTermDays: json['payment_term_days'] ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'phone': phone,
      'email': email,
      'npwp': npwp,
      'credit_limit': creditLimit,
      'payment_term_days': paymentTermDays,
      'is_active': isActive,
      'notes': notes,
    };
  }
}

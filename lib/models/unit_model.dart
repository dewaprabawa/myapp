class UnitResponse {
  final bool success;
  final String? message;
  final List<UnitData> data;

  UnitResponse({required this.success, this.message, required this.data});

  factory UnitResponse.fromJson(Map<String, dynamic> json) {
    return UnitResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List? ?? [])
          .map((e) => UnitData.fromJson(e))
          .toList(),
    );
  }
}

class UnitDetailResponse {
  final bool success;
  final String? message;
  final UnitData data;

  UnitDetailResponse({required this.success, this.message, required this.data});

  factory UnitDetailResponse.fromJson(Map<String, dynamic> json) {
    return UnitDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: UnitData.fromJson(json['data'] ?? {}),
    );
  }
}

class UnitData {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UnitData({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'is_active': isActive};
  }
}

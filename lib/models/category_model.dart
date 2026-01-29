class CategoryResponse {
  final bool success;
  final String? message;
  final List<CategoryData> data;

  CategoryResponse({required this.success, this.message, required this.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List? ?? [])
          .map((e) => CategoryData.fromJson(e))
          .toList(),
    );
  }
}

class CategoryDetailResponse {
  final bool success;
  final String? message;
  final CategoryData data;

  CategoryDetailResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: CategoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class CategoryData {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
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

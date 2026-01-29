import 'package:myapp/models/category_model.dart';
import 'package:myapp/models/unit_model.dart';

class ProductResponse {
  final bool success;
  final List<ProductData> data;
  final PaginationMeta? meta;

  ProductResponse({required this.success, required this.data, this.meta});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => ProductData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class ProductSingleResponse {
  final bool success;
  final ProductData data;

  ProductSingleResponse({required this.success, required this.data});

  factory ProductSingleResponse.fromJson(Map<String, dynamic> json) {
    return ProductSingleResponse(
      success: json['success'] ?? false,
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final int id;
  final int categoryId;
  final String code;
  final String name;
  final String? description;
  final int baseUnitId;
  final double basePrice;
  final String? image;
  final String? productionType;
  final String? packagingContent;
  final int? minStock;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryData? category;
  final UnitData? baseUnit;
  final double? partnerPrice;
  final double? availableStock;

  ProductData({
    required this.id,
    required this.categoryId,
    required this.code,
    required this.name,
    this.description,
    required this.baseUnitId,
    required this.basePrice,
    this.image,
    this.productionType,
    this.packagingContent,
    this.minStock,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.baseUnit,
    this.partnerPrice,
    this.availableStock,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      baseUnitId: json['base_unit_id'] ?? 0,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
      productionType: json['production_type'],
      packagingContent: json['packaging_content'],
      minStock: json['min_stock'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      category: json['category'] != null
          ? CategoryData.fromJson(json['category'])
          : null,
      baseUnit: json['base_unit'] != null
          ? UnitData.fromJson(json['base_unit'])
          : null,
      partnerPrice: (json['partner_price'] as num?)?.toDouble(),
      availableStock: (json['available_stock'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'code': code,
      'name': name,
      'description': description,
      'base_unit_id': baseUnitId,
      'base_price': basePrice,
      'production_type': productionType,
      'packaging_content': packagingContent,
      'min_stock': minStock,
      'is_active': isActive,
    };
  }
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

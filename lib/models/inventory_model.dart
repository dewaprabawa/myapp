import 'package:distributorsfast/models/pagination_model.dart';
import 'package:distributorsfast/models/product_model.dart';

class InventoryResponse {
  final bool success;
  final List<InventoryData> data;
  final PaginationMeta? meta;

  InventoryResponse({required this.success, required this.data, this.meta});

  factory InventoryResponse.fromJson(Map<String, dynamic> json) {
    return InventoryResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => InventoryData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class InventoryData {
  final int id;
  final String warehouseType;
  final int? partnerId;
  final int productId;
  final double quantity;
  final double allocatedQuantity;
  final double availableQuantity;
  final DateTime? lastMovementAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductData? product;

  InventoryData({
    required this.id,
    required this.warehouseType,
    this.partnerId,
    required this.productId,
    required this.quantity,
    required this.allocatedQuantity,
    required this.availableQuantity,
    this.lastMovementAt,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      id: json['id'] ?? 0,
      warehouseType: json['warehouse_type'] ?? '',
      partnerId: json['partner_id'],
      productId: json['product_id'] ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      allocatedQuantity:
          (json['allocated_quantity'] as num?)?.toDouble() ?? 0.0,
      availableQuantity:
          (json['available_quantity'] as num?)?.toDouble() ?? 0.0,
      lastMovementAt: json['last_movement_at'] != null
          ? DateTime.parse(json['last_movement_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      product: json['product'] != null
          ? ProductData.fromJson(json['product'])
          : null,
    );
  }
}

import 'package:myapp/models/pagination_model.dart';
import 'package:myapp/models/partner_model.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/models/unit_model.dart';

class StockOpnameResponse {
  final bool success;
  final List<StockOpnameData> data;
  final PaginationMeta? meta;

  StockOpnameResponse({required this.success, required this.data, this.meta});

  factory StockOpnameResponse.fromJson(Map<String, dynamic> json) {
    return StockOpnameResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => StockOpnameData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class StockOpnameSingleResponse {
  final bool success;
  final StockOpnameData data;

  StockOpnameSingleResponse({required this.success, required this.data});

  factory StockOpnameSingleResponse.fromJson(Map<String, dynamic> json) {
    return StockOpnameSingleResponse(
      success: json['success'] ?? false,
      data: StockOpnameData.fromJson(json['data']),
    );
  }
}

class StockOpnameData {
  final int id;
  final String opnameNumber;
  final int? partnerId;
  final DateTime opnameDate;
  final String status;
  final String? notes;
  final String? photoUrl;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PartnerData? partner;
  final List<StockOpnameItemData> items;

  StockOpnameData({
    required this.id,
    required this.opnameNumber,
    this.partnerId,
    required this.opnameDate,
    required this.status,
    this.notes,
    this.photoUrl,
    this.submittedAt,
    this.approvedAt,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.partner,
    required this.items,
  });

  factory StockOpnameData.fromJson(Map<String, dynamic> json) {
    return StockOpnameData(
      id: json['id'] ?? 0,
      opnameNumber: json['opname_number'] ?? '',
      partnerId: json['partner_id'],
      opnameDate: DateTime.parse(json['opname_date']),
      status: json['status'] ?? 'draft',
      notes: json['notes'],
      photoUrl: json['photo_url'],
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      partner: json['partner'] != null
          ? PartnerData.fromJson(json['partner'])
          : null,
      items:
          (json['items'] as List?)
              ?.map((e) => StockOpnameItemData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StockOpnameItemData {
  final int id;
  final int stockOpnameId;
  final int productId;
  final int unitId;
  final double systemQuantity;
  final double physicalQuantity;
  final double difference;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductData? product;
  final UnitData? unit;

  StockOpnameItemData({
    required this.id,
    required this.stockOpnameId,
    required this.productId,
    required this.unitId,
    required this.systemQuantity,
    required this.physicalQuantity,
    required this.difference,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.unit,
  });

  factory StockOpnameItemData.fromJson(Map<String, dynamic> json) {
    return StockOpnameItemData(
      id: json['id'] ?? 0,
      stockOpnameId: json['stock_opname_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      systemQuantity: (json['system_quantity'] as num?)?.toDouble() ?? 0.0,
      physicalQuantity: (json['physical_quantity'] as num?)?.toDouble() ?? 0.0,
      difference: (json['difference'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      product: json['product'] != null
          ? ProductData.fromJson(json['product'])
          : null,
      unit: json['unit'] != null ? UnitData.fromJson(json['unit']) : null,
    );
  }
}

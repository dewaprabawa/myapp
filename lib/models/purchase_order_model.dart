import 'package:distributorsfast/models/pagination_model.dart';
import 'package:distributorsfast/models/partner_model.dart';
import 'package:distributorsfast/models/product_model.dart';
import 'package:distributorsfast/models/unit_model.dart';

class PurchaseOrderResponse {
  final bool success;
  final List<PurchaseOrderData> data;
  final PaginationMeta? meta;

  PurchaseOrderResponse({required this.success, required this.data, this.meta});

  factory PurchaseOrderResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => PurchaseOrderData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class PurchaseOrderSingleResponse {
  final bool success;
  final PurchaseOrderData data;

  PurchaseOrderSingleResponse({required this.success, required this.data});

  factory PurchaseOrderSingleResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderSingleResponse(
      success: json['success'] ?? false,
      data: PurchaseOrderData.fromJson(json['data']),
    );
  }
}

class PurchaseOrderData {
  final int id;
  final String poNumber;
  final int partnerId;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String status;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final String? notes;
  final String? rejectionReason;
  final DateTime? approvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PartnerData? partner;
  final List<PurchaseOrderItemData> items;

  PurchaseOrderData({
    required this.id,
    required this.poNumber,
    required this.partnerId,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    this.notes,
    this.rejectionReason,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.partner,
    required this.items,
  });

  factory PurchaseOrderData.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderData(
      id: json['id'] ?? 0,
      poNumber: json['po_number'] ?? '',
      partnerId: json['partner_id'] ?? 0,
      orderDate: DateTime.parse(json['order_date']),
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      status: json['status'] ?? 'draft',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'],
      rejectionReason: json['rejection_reason'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
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
              ?.map((e) => PurchaseOrderItemData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PurchaseOrderItemData {
  final int id;
  final int purchaseOrderId;
  final int productId;
  final int? unitId;
  final double quantity;
  final double deliveredQuantity;
  final double? unitPrice;
  final double? totalPrice;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductData? product;
  final UnitData? unit;

  PurchaseOrderItemData({
    required this.id,
    required this.purchaseOrderId,
    required this.productId,
    this.unitId,
    required this.quantity,
    required this.deliveredQuantity,
    this.unitPrice,
    this.totalPrice,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.unit,
  });

  factory PurchaseOrderItemData.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemData(
      id: json['id'] ?? 0,
      purchaseOrderId: json['purchase_order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      unitId: json['unit_id'],
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      deliveredQuantity:
          (json['delivered_quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
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

class PurchaseOrderSummaryResponse {
  final bool success;
  final List<PurchaseOrderSummaryData> data;

  PurchaseOrderSummaryResponse({required this.success, required this.data});

  factory PurchaseOrderSummaryResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderSummaryResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => PurchaseOrderSummaryData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PurchaseOrderSummaryData {
  final String productCode;
  final String productName;
  final String unitName;
  final double totalQuantity;
  final int totalOrders;

  PurchaseOrderSummaryData({
    required this.productCode,
    required this.productName,
    required this.unitName,
    required this.totalQuantity,
    required this.totalOrders,
  });

  factory PurchaseOrderSummaryData.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderSummaryData(
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      unitName: json['unit_name'] ?? '',
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['total_orders'] ?? 0,
    );
  }
}

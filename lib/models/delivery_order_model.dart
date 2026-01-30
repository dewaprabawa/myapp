import 'package:distributorsfast/models/pagination_model.dart';
import 'package:distributorsfast/models/partner_model.dart';
import 'package:distributorsfast/models/product_model.dart';
import 'package:distributorsfast/models/unit_model.dart';

class DeliveryOrderResponse {
  final bool success;
  final List<DeliveryOrderData> data;
  final PaginationMeta? meta;

  DeliveryOrderResponse({required this.success, required this.data, this.meta});

  factory DeliveryOrderResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => DeliveryOrderData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class DeliveryOrderSingleResponse {
  final bool success;
  final DeliveryOrderData data;

  DeliveryOrderSingleResponse({required this.success, required this.data});

  factory DeliveryOrderSingleResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderSingleResponse(
      success: json['success'] ?? false,
      data: DeliveryOrderData.fromJson(json['data']),
    );
  }
}

class DeliveryOrderData {
  final int id;
  final String doNumber;
  final int purchaseOrderId;
  final int partnerId;
  final DateTime deliveryDate;
  final String status;
  final String? driverName;
  final String? vehicleNumber;
  final String? notes;
  final DateTime? receivedDate;
  final String? receivedBy;
  final String? receivedNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PartnerData? partner;
  final List<DeliveryOrderItemData> items;

  DeliveryOrderData({
    required this.id,
    required this.doNumber,
    required this.purchaseOrderId,
    required this.partnerId,
    required this.deliveryDate,
    required this.status,
    this.driverName,
    this.vehicleNumber,
    this.notes,
    this.receivedDate,
    this.receivedBy,
    this.receivedNotes,
    this.createdAt,
    this.updatedAt,
    this.partner,
    required this.items,
  });

  factory DeliveryOrderData.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderData(
      id: json['id'] ?? 0,
      doNumber: json['do_number'] ?? '',
      purchaseOrderId: json['purchase_order_id'] ?? 0,
      partnerId: json['partner_id'] ?? 0,
      deliveryDate: DateTime.parse(json['delivery_date']),
      status: json['status'] ?? 'created',
      driverName: json['driver_name'],
      vehicleNumber: json['vehicle_number'],
      notes: json['notes'],
      receivedDate: json['received_date'] != null
          ? DateTime.parse(json['received_date'])
          : null,
      receivedBy: json['received_by'],
      receivedNotes: json['received_notes'],
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
              ?.map((e) => DeliveryOrderItemData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DeliveryOrderItemData {
  final int id;
  final int deliveryOrderId;
  final int purchaseOrderItemId;
  final int productId;
  final int unitId;
  final double quantity;
  final double? receivedQuantity;
  final String? discrepancyNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductData? product;
  final UnitData? unit;

  DeliveryOrderItemData({
    required this.id,
    required this.deliveryOrderId,
    required this.purchaseOrderItemId,
    required this.productId,
    required this.unitId,
    required this.quantity,
    this.receivedQuantity,
    this.discrepancyNotes,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.unit,
  });

  factory DeliveryOrderItemData.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItemData(
      id: json['id'] ?? 0,
      deliveryOrderId: json['delivery_order_id'] ?? 0,
      purchaseOrderItemId: json['purchase_order_item_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      receivedQuantity: (json['received_quantity'] as num?)?.toDouble(),
      discrepancyNotes: json['discrepancy_notes'],
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

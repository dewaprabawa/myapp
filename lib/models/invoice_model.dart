import 'product_model.dart';
import 'unit_model.dart';
import 'pagination_model.dart';

class InvoiceResponse {
  final bool success;
  final List<InvoiceData> data;
  final PaginationMeta? meta;

  InvoiceResponse({required this.success, required this.data, this.meta});

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => InvoiceData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class InvoiceDetailResponse {
  final bool success;
  final InvoiceData data;

  InvoiceDetailResponse({required this.success, required this.data});

  factory InvoiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailResponse(
      success: json['success'] ?? false,
      data: InvoiceData.fromJson(json['data']),
    );
  }
}

class InvoiceData {
  final int id;
  final String invoiceNumber;
  final int? purchaseOrderId;
  final int partnerId;
  final String invoiceDate;
  final String dueDate;
  final String status;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final String? notes;
  final double outstandingAmount;
  final int daysOverdue;
  final String agingBucket;
  final String createdAt;
  final String updatedAt;
  final List<InvoiceItemData>? items;
  final Map<String, dynamic>? partner;

  InvoiceData({
    required this.id,
    required this.invoiceNumber,
    this.purchaseOrderId,
    required this.partnerId,
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    this.notes,
    required this.outstandingAmount,
    required this.daysOverdue,
    required this.agingBucket,
    required this.createdAt,
    required this.updatedAt,
    this.items,
    this.partner,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      purchaseOrderId: json['purchase_order_id'],
      partnerId: json['partner_id'],
      invoiceDate: json['invoice_date'],
      dueDate: json['due_date'],
      status: json['status'],
      subtotal: (json['subtotal'] as num).toDouble(),
      taxRate: (json['tax_rate'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      notes: json['notes'],
      outstandingAmount: (json['outstanding_amount'] as num).toDouble(),
      daysOverdue: json['days_overdue'] ?? 0,
      agingBucket: json['aging_bucket'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      items: (json['items'] as List?)
          ?.map((e) => InvoiceItemData.fromJson(e))
          .toList(),
      partner: json['partner'],
    );
  }
}

class InvoiceItemData {
  final int id;
  final int invoiceId;
  final int? deliveryOrderId;
  final int productId;
  final int unitId;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final ProductData? product;
  final UnitData? unit;

  InvoiceItemData({
    required this.id,
    required this.invoiceId,
    this.deliveryOrderId,
    required this.productId,
    required this.unitId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.product,
    this.unit,
  });

  factory InvoiceItemData.fromJson(Map<String, dynamic> json) {
    return InvoiceItemData(
      id: json['id'],
      invoiceId: json['invoice_id'],
      deliveryOrderId: json['delivery_order_id'],
      productId: json['product_id'],
      unitId: json['unit_id'],
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      product: json['product'] != null
          ? ProductData.fromJson(json['product'])
          : null,
      unit: json['unit'] != null ? UnitData.fromJson(json['unit']) : null,
    );
  }
}

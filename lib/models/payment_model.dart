import 'pagination_model.dart';
import 'invoice_model.dart';

class PaymentResponse {
  final bool success;
  final List<PaymentData> data;
  final PaginationMeta? meta;

  PaymentResponse({required this.success, required this.data, this.meta});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => PaymentData.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class PaymentDetailResponse {
  final bool success;
  final PaymentData data;

  PaymentDetailResponse({required this.success, required this.data});

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) {
    return PaymentDetailResponse(
      success: json['success'] ?? false,
      data: PaymentData.fromJson(json['data']),
    );
  }
}

class PaymentData {
  final int id;
  final String paymentNumber;
  final int invoiceId;
  final String paymentDate;
  final double amount;
  final String paymentMethod;
  final String? referenceNumber;
  final String? bankName;
  final String? notes;
  final String status;
  final String? rejectionReason;
  final String? approvedAt;
  final String? proofFileUrl;
  final String createdAt;
  final String updatedAt;
  final InvoiceData? invoice;

  PaymentData({
    required this.id,
    required this.paymentNumber,
    required this.invoiceId,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.bankName,
    this.notes,
    required this.status,
    this.rejectionReason,
    this.approvedAt,
    this.proofFileUrl,
    required this.createdAt,
    required this.updatedAt,
    this.invoice,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'],
      paymentNumber: json['payment_number'],
      invoiceId: json['invoice_id'],
      paymentDate: json['payment_date'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      referenceNumber: json['reference_number'],
      bankName: json['bank_name'],
      notes: json['notes'],
      status: json['status'],
      rejectionReason: json['rejection_reason'],
      approvedAt: json['approved_at'],
      proofFileUrl: json['proof_file_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      invoice: json['invoice'] != null
          ? InvoiceData.fromJson(json['invoice'])
          : null,
    );
  }
}

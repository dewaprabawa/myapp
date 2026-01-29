class DashboardResponse {
  final bool success;
  final String message;
  final DashboardData? data;

  DashboardResponse({required this.success, required this.message, this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  final DashboardSummary summary;
  final DashboardAlerts alerts;
  final List<dynamic> topProducts;
  final List<TopPartner> topPartners;
  final List<SalesTrend> salesTrend;

  DashboardData({
    required this.summary,
    required this.alerts,
    required this.topProducts,
    required this.topPartners,
    required this.salesTrend,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      summary: DashboardSummary.fromJson(json['summary'] ?? {}),
      alerts: DashboardAlerts.fromJson(json['alerts'] ?? {}),
      topProducts: json['top_products'] ?? [],
      topPartners: (json['top_partners'] as List? ?? [])
          .map((e) => TopPartner.fromJson(e))
          .toList(),
      salesTrend: (json['sales_trend'] as List? ?? [])
          .map((e) => SalesTrend.fromJson(e))
          .toList(),
    );
  }
}

class DashboardSummary {
  final int pendingPo;
  final int inTransitDo;
  final int unpaidInvoices;
  final String totalReceivable;

  DashboardSummary({
    required this.pendingPo,
    required this.inTransitDo,
    required this.unpaidInvoices,
    required this.totalReceivable,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      pendingPo: json['pending_po'] ?? 0,
      inTransitDo: json['in_transit_do'] ?? 0,
      unpaidInvoices: json['unpaid_invoices'] ?? 0,
      totalReceivable: json['total_receivable']?.toString() ?? '0',
    );
  }
}

class DashboardAlerts {
  final List<dynamic> lowStock;
  final int overdueInvoices;
  final int pendingPoCount;

  DashboardAlerts({
    required this.lowStock,
    required this.overdueInvoices,
    required this.pendingPoCount,
  });

  factory DashboardAlerts.fromJson(Map<String, dynamic> json) {
    return DashboardAlerts(
      lowStock: json['low_stock'] ?? [],
      overdueInvoices: json['overdue_invoices'] ?? 0,
      pendingPoCount: json['pending_po_count'] ?? 0,
    );
  }
}

class TopPartner {
  final String partner;
  final String totalValue;

  TopPartner({required this.partner, required this.totalValue});

  factory TopPartner.fromJson(Map<String, dynamic> json) {
    return TopPartner(
      partner: json['partner'] ?? '',
      totalValue: json['total_value']?.toString() ?? '0',
    );
  }
}

class SalesTrend {
  final String month;
  final double total;

  SalesTrend({required this.month, required this.total});

  factory SalesTrend.fromJson(Map<String, dynamic> json) {
    return SalesTrend(
      month: json['month'] ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }
}

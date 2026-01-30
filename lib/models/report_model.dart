class SalesReportResponse {
  final bool success;
  final SalesReportData data;

  SalesReportResponse({required this.success, required this.data});

  factory SalesReportResponse.fromJson(Map<String, dynamic> json) {
    return SalesReportResponse(
      success: json['success'],
      data: SalesReportData.fromJson(json['data']),
    );
  }
}

class SalesReportData {
  final Map<String, dynamic> summary;
  final List<dynamic> byMonth;
  final Map<String, dynamic>? period;

  SalesReportData({required this.summary, required this.byMonth, this.period});

  factory SalesReportData.fromJson(Map<String, dynamic> json) {
    return SalesReportData(
      summary: json['summary'] ?? {},
      byMonth: json['by_month'] ?? [],
      period: json['period'],
    );
  }
}

class AgingReportResponse {
  final bool success;
  final AgingReportData data;

  AgingReportResponse({required this.success, required this.data});

  factory AgingReportResponse.fromJson(Map<String, dynamic> json) {
    return AgingReportResponse(
      success: json['success'],
      data: AgingReportData.fromJson(json['data']),
    );
  }
}

class AgingReportData {
  final Map<String, dynamic> summary;
  final List<dynamic> invoices;

  AgingReportData({required this.summary, required this.invoices});

  factory AgingReportData.fromJson(Map<String, dynamic> json) {
    return AgingReportData(
      summary: json['summary'] ?? {},
      invoices: json['invoices'] ?? [],
    );
  }
}

class InventoryReportResponse {
  final bool success;
  final InventoryReportData data;

  InventoryReportResponse({required this.success, required this.data});

  factory InventoryReportResponse.fromJson(Map<String, dynamic> json) {
    return InventoryReportResponse(
      success: json['success'],
      data: InventoryReportData.fromJson(json['data']),
    );
  }
}

class InventoryReportData {
  final Map<String, dynamic> summary;
  final List<dynamic> inventory;

  InventoryReportData({required this.summary, required this.inventory});

  factory InventoryReportData.fromJson(Map<String, dynamic> json) {
    return InventoryReportData(
      summary: json['summary'] ?? {},
      inventory: json['inventory'] ?? [],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/report_provider.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() => context.read<ReportProvider>().fetchSalesReport());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sales Report',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.salesReport == null) {
            return const Center(child: Text('Data tidak tersedia.'));
          }

          final summary = provider.salesReport!.summary;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(summary),
                const SizedBox(height: 24),
                _buildChartSection(provider.salesReport!.byMonth),
                const SizedBox(height: 24),
                _buildMonthlyTable(provider.salesReport!.byMonth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(Map<String, dynamic> summary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Total Sales',
          NumberFormat.compactCurrency(
            locale: 'id',
            symbol: 'Rp ',
          ).format(summary['total_revenue'] ?? 0),
          Icons.payments_rounded,
          const Color(0xFF4C6FFF),
        ),
        _buildSummaryCard(
          'Total Invoices',
          (summary['total_invoices'] ?? 0).toString(),
          Icons.description_rounded,
          const Color(0xFF10B981),
        ),
        _buildSummaryCard(
          'Avg Order',
          NumberFormat.compactCurrency(
            locale: 'id',
            symbol: 'Rp ',
          ).format(summary['average_invoice_value'] ?? 0),
          Icons.analytics_rounded,
          const Color(0xFF8B5CF6),
        ),
        _buildSummaryCard(
          'Partners',
          (summary['total_partners'] ?? 0).toString(),
          Icons.people_rounded,
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<dynamic> monthlyData) {
    if (monthlyData.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Trend',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= monthlyData.length)
                          return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthlyData[index]['month_name']?.substring(0, 3) ??
                                '',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        (e.value['total_revenue'] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF4C6FFF),
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF4C6FFF).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTable(List<dynamic> monthlyData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Monthly Breakdown',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(
                label: Text(
                  'Month',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Sales',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Orders',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: monthlyData.map((data) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      data['month_name'],
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      NumberFormat.compactCurrency(
                        locale: 'id',
                        symbol: 'Rp ',
                      ).format(data['total_revenue']),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      data['total_invoices'].toString(),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/report_provider.dart';

class InventoryReportScreen extends StatefulWidget {
  const InventoryReportScreen({super.key});

  @override
  State<InventoryReportScreen> createState() => _InventoryReportScreenState();
}

class _InventoryReportScreenState extends State<InventoryReportScreen> {
  String _inventoryType = 'central';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(
      () => context.read<ReportProvider>().fetchInventoryReport(
        type: _inventoryType,
      ),
    );
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
          'Inventory Report',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTypeSelector(),
          Expanded(
            child: Consumer<ReportProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                if (provider.inventoryReport == null) {
                  return const Center(child: Text('Data tidak tersedia.'));
                }

                final summary = provider.inventoryReport!.summary;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummarySection(summary),
                      const SizedBox(height: 24),
                      _buildInventoryTable(provider.inventoryReport!.inventory),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTypeButton('central', 'Gudang Pusat'),
          const SizedBox(width: 12),
          _buildTypeButton('partner', 'Partner/Distributor'),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, String label) {
    bool isSelected = _inventoryType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _inventoryType = type;
        });
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
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
          'Total Items',
          (summary['total_items'] ?? 0).toString(),
          Icons.inventory_2_rounded,
          const Color(0xFF4C6FFF),
        ),
        _buildSummaryCard(
          'Total Value',
          NumberFormat.compactCurrency(
            locale: 'id',
            symbol: 'Rp ',
          ).format(summary['total_value'] ?? 0),
          Icons.account_balance_wallet_rounded,
          const Color(0xFF10B981),
        ),
        _buildSummaryCard(
          'Low Stock',
          (summary['low_stock_items'] ?? 0).toString(),
          Icons.warning_rounded,
          const Color(0xFFEF4444),
        ),
        _buildSummaryCard(
          'Categories',
          (summary['total_categories'] ?? 0).toString(),
          Icons.category_rounded,
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

  Widget _buildInventoryTable(List<dynamic> inventory) {
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
              'Stock Breakdown',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Product',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unit',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Value',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: inventory.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item['product_name'] ?? '',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                    DataCell(
                      Text(
                        item['stock_quantity'].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              (item['stock_quantity'] as num) <=
                                  (item['min_stock'] ?? 0)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item['unit_name'] ?? '',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                    DataCell(
                      Text(
                        NumberFormat.compactCurrency(
                          locale: 'id',
                          symbol: 'Rp ',
                        ).format(item['stock_value']),
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

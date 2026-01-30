import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/report_provider.dart';

class AgingReportScreen extends StatefulWidget {
  const AgingReportScreen({super.key});

  @override
  State<AgingReportScreen> createState() => _AgingReportScreenState();
}

class _AgingReportScreenState extends State<AgingReportScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Future.microtask(() => context.read<ReportProvider>().fetchAgingReport());
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
          'Aging Report',
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
          if (provider.agingReport == null) {
            return const Center(child: Text('Data tidak tersedia.'));
          }

          final summary = provider.agingReport!.summary;
          final buckets =
              summary['by_aging_bucket'] as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalOutstanding(summary['total_outstanding'] ?? 0),
                const SizedBox(height: 24),
                _buildBucketSection(buckets),
                const SizedBox(height: 24),
                _buildInvoiceList(provider.agingReport!.invoices),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalOutstanding(dynamic amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Total Outstanding',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(amount),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBucketSection(Map<String, dynamic> buckets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aging Buckets',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildBucketCard(
              'Not Due',
              buckets['not_due'] ?? 0,
              const Color(0xFF10B981),
            ),
            const SizedBox(width: 12),
            _buildBucketCard(
              '1-30 Days',
              buckets['1_30_days'] ?? 0,
              const Color(0xFFF59E0B),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildBucketCard(
              '31-60 Days',
              buckets['31_60_days'] ?? 0,
              const Color(0xFFEF4444),
            ),
            const SizedBox(width: 12),
            _buildBucketCard(
              '60+ Days',
              buckets['over_60_days'] ?? 0,
              const Color(0xFFB91C1C),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBucketCard(String label, dynamic amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 4)),
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
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              NumberFormat.compactCurrency(
                locale: 'id',
                symbol: 'Rp ',
              ).format(amount),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(List<dynamic> invoices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overdue Invoices',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        ...invoices.map((inv) => _buildInvoiceTile(inv)),
      ],
    );
  }

  Widget _buildInvoiceTile(Map<String, dynamic> inv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv['invoice_number'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  inv['partner_name'] ?? 'Partner N/A',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.compactCurrency(
                  locale: 'id',
                  symbol: 'Rp ',
                ).format(inv['outstanding_amount']),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: const Color(0xFFEF4444),
                ),
              ),
              Text(
                '${inv['days_overdue']} days overdue',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFFB91C1C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

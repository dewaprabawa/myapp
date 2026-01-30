import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/stock_opname_provider.dart';
import 'package:myapp/models/stock_opname_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StockOpnameDetailScreen extends StatefulWidget {
  final int opnameId;

  const StockOpnameDetailScreen({super.key, required this.opnameId});

  @override
  State<StockOpnameDetailScreen> createState() =>
      _StockOpnameDetailScreenState();
}

class _StockOpnameDetailScreenState extends State<StockOpnameDetailScreen> {
  StockOpnameData? _opname;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      final detail = await context
          .read<StockOpnameProvider>()
          .fetchStockOpnameDetail(token, widget.opnameId);
      if (mounted) {
        setState(() {
          _opname = detail;
          _isLoading = false;
        });
      }
    }
  }

  void _handleAction(String action) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    bool success = false;
    String message = '';

    if (action == 'submit') {
      success = await context.read<StockOpnameProvider>().submitStockOpname(
        token,
        widget.opnameId,
      );
      message = 'Opname berhasil disubmit';
    } else if (action == 'approve') {
      success = await context.read<StockOpnameProvider>().approveStockOpname(
        token,
        widget.opnameId,
      );
      message = 'Opname berhasil disetujui';
    } else if (action == 'reject') {
      final reason = await _showRejectDialog();
      if (reason != null && reason.isNotEmpty) {
        success = await context.read<StockOpnameProvider>().rejectStockOpname(
          token,
          widget.opnameId,
          reason,
        );
        message = 'Opname berhasil direject';
      } else {
        return;
      }
    }

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      _loadDetail();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<StockOpnameProvider>().errorMessage ??
                'Gagal melakukan aksi',
          ),
        ),
      );
    }
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Opname'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Alasan penolakan...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_opname == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _opname!.opnameNumber,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildItemsList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStatusCard() {
    Color color;
    switch (_opname!.status.toLowerCase()) {
      case 'draft':
        color = Colors.grey;
        break;
      case 'submitted':
        color = Colors.blue;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'STATUS: ${_opname!.status.toUpperCase()}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (_opname!.status.toLowerCase() == 'rejected' &&
              _opname!.rejectionReason != null)
            Flexible(
              child: Text(
                _opname!.rejectionReason!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow('Gudang', _opname!.partner?.name ?? 'Head Office'),
          const Divider(),
          _buildInfoRow(
            'Tanggal',
            DateFormat('dd MMMM yyyy').format(_opname!.opnameDate),
          ),
          const Divider(),
          _buildInfoRow('Catatan', _opname!.notes ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._opname!.items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.name ?? '-',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQtyColumn('Sistem', item.systemQuantity),
                    _buildQtyColumn('Fisik', item.physicalQuantity),
                    _buildQtyColumn('Selisih', item.difference, isDiff: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQtyColumn(String label, double qty, {bool isDiff = false}) {
    Color valColor = Colors.black;
    if (isDiff) {
      valColor = qty == 0 ? Colors.green : Colors.red;
    }
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          qty.toStringAsFixed(0),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: valColor,
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomActions() {
    final status = _opname!.status.toLowerCase();
    if (status == 'approved' || status == 'rejected') return null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          if (status == 'draft')
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleAction('submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Opname'),
              ),
            ),
          if (status == 'submitted') ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleAction('reject'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Reject'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleAction('approve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Approve'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

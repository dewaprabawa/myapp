import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:distributorsfast/providers/auth_provider.dart';
import 'package:distributorsfast/providers/delivery_order_provider.dart';
import 'package:distributorsfast/models/delivery_order_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DeliveryOrderDetailScreen extends StatefulWidget {
  final int doId;

  const DeliveryOrderDetailScreen({super.key, required this.doId});

  @override
  State<DeliveryOrderDetailScreen> createState() =>
      _DeliveryOrderDetailScreenState();
}

class _DeliveryOrderDetailScreenState extends State<DeliveryOrderDetailScreen> {
  DeliveryOrderData? _deliveryOrder;
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
          .read<DeliveryOrderProvider>()
          .fetchDeliveryOrderDetail(token, widget.doId);
      if (mounted) {
        setState(() {
          _deliveryOrder = detail;
          _isLoading = false;
        });
      }
    }
  }

  void _confirmReceipt() async {
    if (_deliveryOrder == null) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ConfirmReceiptForm(deliveryOrder: _deliveryOrder!),
    );

    if (result != null) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        final success = await context
            .read<DeliveryOrderProvider>()
            .confirmDeliveryOrder(token, widget.doId, result);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penerimaan berhasil dikonfirmasi')),
          );
          _loadDetail();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.read<DeliveryOrderProvider>().errorMessage ??
                    'Gagal konfirmasi',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_deliveryOrder == null) {
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
          _deliveryOrder!.doNumber,
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
            if (_deliveryOrder!.status.toLowerCase() == 'delivered') ...[
              const SizedBox(height: 20),
              _buildReceiptCard(),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _deliveryOrder!.status.toLowerCase() == 'in_transit'
          ? Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: _confirmReceipt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Konfirmasi Penerimaan'),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusCard() {
    Color color;
    switch (_deliveryOrder!.status.toLowerCase()) {
      case 'created':
        color = Colors.blue;
        break;
      case 'in_transit':
        color = Colors.orange;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
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
      child: Text(
        'STATUS: ${_deliveryOrder!.status.toUpperCase().replaceAll('_', ' ')}',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: color),
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
          _buildInfoRow('Partner', _deliveryOrder!.partner?.name ?? '-'),
          const Divider(),
          _buildInfoRow(
            'Tanggal Kirim',
            DateFormat('dd MMMM yyyy').format(_deliveryOrder!.deliveryDate),
          ),
          const Divider(),
          _buildInfoRow('Driver', _deliveryOrder!.driverName ?? '-'),
          const Divider(),
          _buildInfoRow('No. Kendaraan', _deliveryOrder!.vehicleNumber ?? '-'),
          const Divider(),
          _buildInfoRow('Catatan', _deliveryOrder!.notes ?? '-'),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Info Penerimaan',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Diterima Oleh', _deliveryOrder!.receivedBy ?? '-'),
          _buildInfoRow(
            'Tanggal Terima',
            _deliveryOrder!.receivedDate != null
                ? DateFormat(
                    'dd MMMM yyyy',
                  ).format(_deliveryOrder!.receivedDate!)
                : '-',
          ),
          _buildInfoRow('Catatan Terima', _deliveryOrder!.receivedNotes ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
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
          'Daftar Barang',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._deliveryOrder!.items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product?.name ?? '-',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.product?.code ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.quantity.toStringAsFixed(0)} ${item.unit?.name ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (item.receivedQuantity != null)
                      Text(
                        'Diterima: ${item.receivedQuantity!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmReceiptForm extends StatefulWidget {
  final DeliveryOrderData deliveryOrder;

  const _ConfirmReceiptForm({required this.deliveryOrder});

  @override
  State<_ConfirmReceiptForm> createState() => _ConfirmReceiptFormState();
}

class _ConfirmReceiptFormState extends State<_ConfirmReceiptForm> {
  final _receivedByController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _receivedDate = DateTime.now();
  late List<Map<String, dynamic>> _itemInputs;

  @override
  void initState() {
    super.initState();
    _itemInputs = widget.deliveryOrder.items
        .map(
          (item) => {
            'product_id': item.productId,
            'received_quantity': item.quantity,
            'discrepancy_notes': '',
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konfirmasi Penerimaan',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _receivedByController,
              decoration: const InputDecoration(
                labelText: 'Diterima Oleh',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan Umum',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Barang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(widget.deliveryOrder.items.length, (index) {
              final item = widget.deliveryOrder.items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product?.name ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.quantity.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah Diterima',
                              isDense: true,
                            ),
                            onChanged: (val) =>
                                _itemInputs[index]['received_quantity'] =
                                    double.tryParse(val) ?? 0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('dari '),
                        Text(
                          item.quantity.toStringAsFixed(0),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_receivedByController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nama penerima harus diisi'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'received_date': DateFormat(
                      'yyyy-MM-dd',
                    ).format(_receivedDate),
                    'received_by': _receivedByController.text,
                    'notes': _notesController.text,
                    'items': _itemInputs,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Konfirmasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

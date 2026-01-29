import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/partner_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/partner_provider.dart';
import 'package:myapp/screens/master_data/sections/add_partner_screen.dart';
import 'package:myapp/shared/base_color.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PartnerDetailScreen extends StatefulWidget {
  final int partnerId;
  const PartnerDetailScreen({super.key, required this.partnerId});

  @override
  State<PartnerDetailScreen> createState() => _PartnerDetailScreenState();
}

class _PartnerDetailScreenState extends State<PartnerDetailScreen> {
  PartnerData? partner;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPartnerDetail();
  }

  Future<void> _fetchPartnerDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      if (auth.token == null) return;

      final data = await context.read<PartnerProvider>().fetchPartnerDetail(
        auth.token!,
        widget.partnerId,
      );

      if (mounted) {
        setState(() {
          partner = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : partner == null
          ? const Center(child: Text('Partner tidak ditemukan'))
          : RefreshIndicator(
              onRefresh: _fetchPartnerDetail,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPartnerHeader(),
                    const SizedBox(height: 16),
                    _buildContactCard(),
                    const SizedBox(height: 16),
                    _buildFinancialCard(),
                    const SizedBox(height: 16),
                    _buildAddressCard(),
                    const SizedBox(height: 16),
                    _buildSystemInfoCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        'Detail Partner',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        if (partner != null)
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPartnerScreen(partner: partner),
                  ),
                );
                if (result == true) {
                  _fetchPartnerDetail();
                }
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: Color(0xFFEF4444),
                    ),
                    SizedBox(width: 12),
                    Text('Hapus', style: TextStyle(color: Color(0xFFEF4444))),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1A1A1A)),
          ),
      ],
    );
  }

  Widget _buildPartnerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kode Partner',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      (partner!.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444))
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  partner!.isActive ? 'Aktif' : 'Non-Aktif',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: partner!.isActive
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            partner!.code,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            partner!.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'NPWP',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            partner!.npwp?.isNotEmpty == true ? partner!.npwp! : '-',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return _buildInfoCard(
      title: 'Informasi Kontak',
      icon: Icons.contact_phone_outlined,
      children: [
        _buildDetailItem(label: 'Email', value: partner!.email ?? '-'),
        const SizedBox(height: 16),
        _buildDetailItem(label: 'Telepon', value: partner!.phone ?? '-'),
      ],
    );
  }

  Widget _buildFinancialCard() {
    return _buildInfoCard(
      title: 'Informasi Keuangan',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        _buildDetailItem(
          label: 'Limit Kredit',
          value: NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(partner!.creditLimit),
          valueColor: BaseColor.primaryColor,
        ),
        const SizedBox(height: 16),
        _buildDetailItem(
          label: 'Termin Pembayaran',
          value: '${partner!.paymentTermDays} Hari',
        ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return _buildInfoCard(
      title: 'Alamat',
      icon: Icons.location_on_outlined,
      children: [
        _buildDetailItem(
          label: 'Alamat Lengkap',
          value: partner!.address ?? '-',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                label: 'Kota',
                value: partner!.city ?? '-',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                label: 'Provinsi',
                value: partner!.province ?? '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailItem(label: 'Kode Pos', value: partner!.postalCode ?? '-'),
      ],
    );
  }

  Widget _buildSystemInfoCard() {
    return _buildInfoCard(
      title: 'Informasi Sistem',
      icon: Icons.info_outline_rounded,
      children: [
        _buildDetailItem(label: 'ID Partner', value: partner!.id.toString()),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                label: 'Dibuat Pada',
                value: partner!.createdAt != null
                    ? DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(partner!.createdAt!)
                    : '-',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                label: 'Diperbarui Pada',
                value: partner!.updatedAt != null
                    ? DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(partner!.updatedAt!)
                    : '-',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: BaseColor.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
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
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Partner',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus partner "${partner?.name}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: const Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = context.read<AuthProvider>();
              if (auth.token == null) return;

              final success = await context
                  .read<PartnerProvider>()
                  .deletePartner(auth.token!, partner!.id);
              if (success) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Partner berhasil dihapus')),
                  );
                  Navigator.pop(context, true);
                }
              } else {
                if (mounted) {
                  final error = context.read<PartnerProvider>().errorMessage;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error ?? 'Gagal menghapus partner'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

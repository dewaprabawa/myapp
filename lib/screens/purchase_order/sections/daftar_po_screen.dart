import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:distributorsfast/screens/widgets/notification_icons.dart';
import 'package:distributorsfast/shared/base_color.dart';
import 'package:provider/provider.dart';
import 'package:distributorsfast/providers/auth_provider.dart';
import 'package:distributorsfast/providers/purchase_order_provider.dart';
import 'package:distributorsfast/providers/partner_provider.dart';
import 'package:intl/intl.dart';

class DaftarPOScreen extends StatefulWidget {
  const DaftarPOScreen({super.key});

  @override
  State<DaftarPOScreen> createState() => _DaftarPOScreenState();
}

class _DaftarPOScreenState extends State<DaftarPOScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _selectedPartnerId;
  String? _selectedStatus;
  int _itemsPerPage = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadPartners();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadData(loadMore: true);
    }
  }

  void _loadData({bool loadMore = false}) {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<PurchaseOrderProvider>().fetchPurchaseOrders(
        token,
        loadMore: loadMore,
        search: _searchController.text.isEmpty ? null : _searchController.text,
        partnerId: _selectedPartnerId,
        status: _selectedStatus?.toLowerCase(),
        perPage: _itemsPerPage,
      );
    }
  }

  void _loadPartners() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<PartnerProvider>().fetchPartners(token, perPage: 100);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFilterSection(),
              ],
            ),
          ),
          Expanded(child: _buildDataTable()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: BaseColor.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Inventory',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
      actions: [NotificationIcons()],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: BaseColor.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.inventory_2_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Inventory',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: Text('Dashboard', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_rounded),
              title: Text('Purchase Order', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase Order',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kelola Purchase Order dari partner',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF6B7280),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Cari & Filter',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nomor PO...',
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: BaseColor.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Partner dropdown
          Consumer<PartnerProvider>(
            builder: (context, partnerProvider, _) {
              return DropdownButtonFormField<int>(
                value: _selectedPartnerId,
                decoration: InputDecoration(
                  hintText: 'Pilih Partner',
                  hintStyle: GoogleFonts.poppins(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: BaseColor.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: partnerProvider.partners
                    .map(
                      (partner) => DropdownMenuItem(
                        value: partner.id,
                        child: Text(
                          partner.name,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPartnerId = value;
                  });
                  _loadData();
                },
              );
            },
          ),
          const SizedBox(height: 12),
          // Status dropdown
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              hintText: 'Status',
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: BaseColor.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items: ['Pending', 'Approved', 'Completed', 'Cancelled']
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          // Reset button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedPartnerId = null;
                  _selectedStatus = null;
                });
                _loadData();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Consumer<PurchaseOrderProvider>(
      builder: (context, poProvider, _) {
        if (poProvider.isLoading && poProvider.purchaseOrders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (poProvider.errorMessage != null &&
            poProvider.purchaseOrders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  Text(poProvider.errorMessage!),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (poProvider.purchaseOrders.isEmpty) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada data',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada purchase order yang tersedia',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildTableHeader('NO. PO')),
                    Expanded(flex: 3, child: _buildTableHeader('PARTNER')),
                    Expanded(flex: 2, child: _buildTableHeader('TANGGAL')),
                    Expanded(flex: 2, child: _buildTableHeader('STATUS')),
                  ],
                ),
              ),
              // Data rows
              ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    poProvider.purchaseOrders.length +
                    (poProvider.isLoading ? 1 : 0),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index == poProvider.purchaseOrders.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final po = poProvider.purchaseOrders[index];
                  return InkWell(
                    onTap: () {
                      // Navigate to detail
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              po.poNumber,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: BaseColor.primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              po.partner?.name ?? '-',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(po.orderDate),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildStatusBadge(po.status),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'draft':
        color = Colors.grey;
        break;
      case 'submitted':
        color = Colors.blue;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.teal;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'rejected':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.unfold_more_rounded,
          size: 16,
          color: Color(0xFF9CA3AF),
        ),
      ],
    );
  }
}

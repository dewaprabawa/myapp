import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/widgets/notification_icons.dart';
import 'package:myapp/shared/base_color.dart';

class PartnerDistributorScreen extends StatefulWidget {
  const PartnerDistributorScreen({super.key});

  @override
  State<PartnerDistributorScreen> createState() =>
      _PartnerDistributorScreenState();
}

class _PartnerDistributorScreenState extends State<PartnerDistributorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  String? selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildAddButton(),
            const SizedBox(height: 20),
            _buildSearchAndFilter(),
            const SizedBox(height: 24),
            _buildProductList(),
          ],
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
      actions: const [NotificationIcons()],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: BaseColor.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Inventory',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home_rounded),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt_rounded),
                title: const Text('Master Data'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Distributor',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kelola master data partner distributor',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Tambah Partner Distributor',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: BaseColor.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
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
        children: [
          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari Partner Distributor...',
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Row
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  hint: 'Status',
                  value: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search_rounded, size: 20),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BaseColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      selectedCategory = null;
                      selectedStatus = null;
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF6B7280),
          ),
          items: const [],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final products = [
      {
        'code': '11131080-001',
        'name': 'HS BOLD 10',
        'price': 'Rp 45.000',
        'status': 'TERSEDIA',
        'statusColor': const Color(0xFF10B981),
      },
      {
        'code': '11131080-002',
        'name': 'HS LIGHT 5',
        'price': 'Rp 32.500',
        'status': 'TERSEDIA',
        'statusColor': const Color(0xFF10B981),
      },
      {
        'code': '11131080-003',
        'name': 'HS REGULAR 8',
        'price': 'Rp 38.000',
        'status': 'HABIS',
        'statusColor': const Color(0xFFEF4444),
      },
      {
        'code': '11131080-004',
        'name': 'HS PREMIUM 12',
        'price': 'Rp 55.000',
        'status': 'TERSEDIA',
        'statusColor': const Color(0xFF10B981),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DAFTAR PRODUK',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${products.length} Produk',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProductCard(
              code: product['code'] as String,
              name: product['name'] as String,
              price: product['price'] as String,
              status: product['status'] as String,
              statusColor: product['statusColor'] as Color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String code,
    required String name,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF6B7280),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF4C6FFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'HARGA',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: const Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

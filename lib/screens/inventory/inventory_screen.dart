import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:distributorsfast/screens/widgets/notification_icons.dart';
import 'package:provider/provider.dart';
import 'package:distributorsfast/providers/auth_provider.dart';
import 'package:distributorsfast/providers/inventory_provider.dart';
import 'package:distributorsfast/providers/category_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  bool _showLowStockOnly = false;
  int _itemsPerPage = 15;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadCategories();
    });
  }

  void _loadData() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<InventoryProvider>().fetchInventories(
        token,
        search: _searchController.text.isEmpty ? null : _searchController.text,
        categoryId: _selectedCategoryId,
        lowStock: _showLowStockOnly ? true : null,
        perPage: _itemsPerPage,
      );
    }
  }

  void _loadCategories() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<CategoryProvider>().fetchCategories(token);
    }
  }

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFilterSection(),
            const SizedBox(height: 24),
            _buildDataTable(),
            const SizedBox(height: 20),
            _buildPagination(),
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
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Inventory Management',
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stok Barang',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pantau dan kelola stok barang di gudang secara real-time.',
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _currentPage = 1);
              _loadData();
            },
            decoration: InputDecoration(
              hintText: 'Cari produk atau kode...',
              hintStyle: GoogleFonts.poppins(color: const Color(0xFF9CA3AF)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _selectedCategoryId,
                          hint: Text(
                            'Semua Kategori',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('Semua Kategori'),
                            ),
                            ...categoryProvider.categories.map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                              _currentPage = 1;
                            });
                            _loadData();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: _showLowStockOnly
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _showLowStockOnly
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Low Stock',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _showLowStockOnly
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF374151),
                      ),
                    ),
                    Switch.adaptive(
                      value: _showLowStockOnly,
                      activeColor: const Color(0xFFEF4444),
                      onChanged: (value) {
                        setState(() {
                          _showLowStockOnly = value;
                          _currentPage = 1;
                        });
                        _loadData();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedCategoryId = null;
                  _showLowStockOnly = false;
                  _currentPage = 1;
                });
                _loadData();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset Filter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, _) {
        if (inventoryProvider.isLoading && _currentPage == 1) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(50.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (inventoryProvider.errorMessage != null) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(inventoryProvider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (inventoryProvider.inventories.isEmpty) {
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada data stok',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ],
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
                    Expanded(flex: 3, child: _buildTableHeader('PRODUK')),
                    Expanded(flex: 2, child: _buildTableHeader('GUDANG')),
                    Expanded(flex: 2, child: _buildTableHeader('STOK')),
                    Expanded(flex: 2, child: _buildTableHeader('TERSEDIA')),
                  ],
                ),
              ),
              // Data rows
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: inventoryProvider.inventories.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = inventoryProvider.inventories[index];
                  final bool isLowStock =
                      item.product?.minStock != null &&
                      item.availableQuantity <= item.product!.minStock!;

                  return InkWell(
                    onTap: () {
                      // Detail movement
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product?.name ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item.product?.code ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.warehouseType.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.quantity.toStringAsFixed(0),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  item.availableQuantity.toStringAsFixed(0),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF10B981),
                                  ),
                                ),
                                if (isLowStock)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      size: 14,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                              ],
                            ),
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

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF6B7280),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPagination() {
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        final meta = provider.meta;
        if (meta == null) return const SizedBox.shrink();

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaginationButton(
                icon: Icons.chevron_left_rounded,
                onTap: (meta.currentPage > 1)
                    ? () {
                        setState(() => _currentPage--);
                        _loadData();
                      }
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                'Halaman ${meta.currentPage} dari ${meta.lastPage}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(width: 16),
              _buildPaginationButton(
                icon: Icons.chevron_right_rounded,
                onTap: (meta.currentPage < meta.lastPage)
                    ? () {
                        setState(() => _currentPage++);
                        _loadData();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
            color: onTap == null ? const Color(0xFFF9FAFB) : Colors.transparent,
          ),
          child: Icon(
            icon,
            size: 20,
            color: onTap == null
                ? const Color(0xFFD1D5DB)
                : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}

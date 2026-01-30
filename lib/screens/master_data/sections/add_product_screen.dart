import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:distributorsfast/models/product_model.dart';
import 'package:distributorsfast/providers/auth_provider.dart';
import 'package:distributorsfast/providers/category_provider.dart';
import 'package:distributorsfast/providers/product_provider.dart';
import 'package:distributorsfast/providers/unit_provider.dart';
import 'package:distributorsfast/screens/widgets/notification_icons.dart';
import 'package:distributorsfast/shared/base_color.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final ProductData? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int? selectedCategoryId;
  int? selectedUnitId;
  bool isActiveProduct = true;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productCodeController.text = widget.product!.code;
      _productNameController.text = widget.product!.name;
      _basePriceController.text = widget.product!.basePrice.toString();
      _minStockController.text = widget.product!.minStock?.toString() ?? '';
      _productTypeController.text = widget.product!.productionType ?? '';
      _packagingController.text = widget.product!.packagingContent ?? '';
      _descriptionController.text = widget.product!.description ?? '';
      selectedCategoryId = widget.product!.categoryId;
      selectedUnitId = widget.product!.baseUnitId;
      isActiveProduct = widget.product!.isActive;
    }
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _productNameController.dispose();
    _basePriceController.dispose();
    _minStockController.dispose();
    _productTypeController.dispose();
    _packagingController.dispose();
    _descriptionController.dispose();
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFormFields(),
              const SizedBox(height: 24),
              _buildActionButtons(),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product == null ? 'Tambah Produk' : 'Edit Produk',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.product == null
              ? 'Tambah produk baru ke katalog'
              : 'Perbarui informasi produk',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF4C6FFF),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
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
          _buildTextField(
            label: 'Kode Produk',
            hint: 'Contoh: PR0001',
            controller: _productCodeController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Nama Produk',
            hint: 'Nama produk',
            controller: _productNameController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          Consumer<CategoryProvider>(
            builder: (context, provider, _) {
              return _buildDropdownField<int>(
                label: 'Kategori',
                hint: 'Pilih kategori',
                value: selectedCategoryId,
                isRequired: true,
                items: provider.categories.map((c) {
                  return DropdownMenuItem<int>(
                    value: c.id,
                    child: Text(
                      c.name,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<UnitProvider>(
            builder: (context, provider, _) {
              return _buildDropdownField<int>(
                label: 'Satuan Dasar',
                hint: 'Pilih satuan',
                value: selectedUnitId,
                isRequired: true,
                items: provider.units.map((u) {
                  return DropdownMenuItem<int>(
                    value: u.id,
                    child: Text(
                      u.name,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUnitId = value;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Harga Dasar',
            hint: 'Rp 0.00',
            controller: _basePriceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Stok Minimum',
            hint: '0',
            controller: _minStockController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Jenis Produksi',
            hint: 'Contoh: SKT, SKM, dsml',
            controller: _productTypeController,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Isi / Kemasan',
            hint: 'Contoh: 12 Botol, 16 Botol',
            controller: _packagingController,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Deskripsi',
            hint: 'Deskripsi produk (opsional)',
            controller: _descriptionController,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          _buildActiveToggle(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
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
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label harus diisi';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T>(
              isExpanded: true,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280),
              ),
              items: items,
              onChanged: onChanged,
              validator: isRequired
                  ? (value) {
                      if (value == null) {
                        return '$label harus dipilih';
                      }
                      return null;
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Produk Aktif',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        Switch(
          value: isActiveProduct,
          onChanged: (value) {
            setState(() {
              isActiveProduct = value;
            });
          },
          activeColor: BaseColor.primaryColor,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final auth = context.read<AuthProvider>();
                          if (auth.token == null) return;

                          final product = ProductData(
                            id: widget.product?.id ?? 0,
                            categoryId: selectedCategoryId!,
                            code: _productCodeController.text,
                            name: _productNameController.text,
                            description: _descriptionController.text,
                            baseUnitId: selectedUnitId!,
                            basePrice:
                                double.tryParse(_basePriceController.text) ?? 0,
                            productionType: _productTypeController.text,
                            packagingContent: _packagingController.text,
                            minStock: int.tryParse(_minStockController.text),
                            isActive: isActiveProduct,
                          );

                          bool success;
                          if (widget.product == null) {
                            success = await provider.addProduct(
                              auth.token!,
                              product,
                            );
                          } else {
                            success = await provider.updateProduct(
                              auth.token!,
                              product,
                            );
                          }

                          if (success) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.product == null
                                        ? 'Produk berhasil ditambahkan!'
                                        : 'Produk berhasil diperbarui!',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                              Navigator.pop(context, true);
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.errorMessage ??
                                        'Gagal menyimpan produk',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColor.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            widget.product == null
                                ? 'Tambah Produk'
                                : 'Simpan Perubahan',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

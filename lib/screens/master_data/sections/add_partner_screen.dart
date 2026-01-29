import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/partner_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/partner_provider.dart';
import 'package:myapp/shared/base_color.dart';
import 'package:provider/provider.dart';

class AddPartnerScreen extends StatefulWidget {
  final PartnerData? partner;
  const AddPartnerScreen({super.key, this.partner});

  @override
  State<AddPartnerScreen> createState() => _AddPartnerScreenState();
}

class _AddPartnerScreenState extends State<AddPartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _paymentTermController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.partner != null) {
      _codeController.text = widget.partner!.code;
      _nameController.text = widget.partner!.name;
      _addressController.text = widget.partner!.address ?? '';
      _cityController.text = widget.partner!.city ?? '';
      _provinceController.text = widget.partner!.province ?? '';
      _postalCodeController.text = widget.partner!.postalCode ?? '';
      _phoneController.text = widget.partner!.phone ?? '';
      _emailController.text = widget.partner!.email ?? '';
      _npwpController.text = widget.partner!.npwp ?? '';
      _creditLimitController.text = widget.partner!.creditLimit.toString();
      _paymentTermController.text = widget.partner!.paymentTermDays.toString();
      _notesController.text = widget.partner!.notes ?? '';
      _isActive = widget.partner!.isActive;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _npwpController.dispose();
    _creditLimitController.dispose();
    _paymentTermController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildSectionTitle('Informasi Dasar'),
              const SizedBox(height: 16),
              _buildTextField(
                'Kode Partner',
                _codeController,
                true,
                hint: 'Contoh: PRT-001',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Nama Partner',
                _nameController,
                true,
                hint: 'Nama Lengkap Distributor',
              ),
              const SizedBox(height: 16),
              _buildTextField('NPWP', _npwpController, false, hint: 'Opsional'),

              const SizedBox(height: 32),
              _buildSectionTitle('Kontak & Alamat'),
              const SizedBox(height: 16),
              _buildTextField(
                'Email',
                _emailController,
                false,
                hint: 'alamat@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Nomor Telepon',
                _phoneController,
                false,
                hint: '0812xxxxxxxx',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Alamat Lengkap',
                _addressController,
                false,
                hint: 'Jalan, No Rumah/Blok',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Kota', _cityController, false),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Provinsi',
                      _provinceController,
                      false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Kode Pos',
                _postalCodeController,
                false,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('Keuangan'),
              const SizedBox(height: 16),
              _buildTextField(
                'Limit Kredit',
                _creditLimitController,
                true,
                keyboardType: TextInputType.number,
                prefixText: 'Rp ',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Termin Pembayaran (Hari)',
                _paymentTermController,
                true,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('Lainnya'),
              const SizedBox(height: 16),
              _buildTextField('Catatan', _notesController, false, maxLines: 3),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status Aktif',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: BaseColor.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.partner == null ? 'Tambah Partner' : 'Edit Partner',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.partner == null ? 'Registrasi Partner' : 'Perbarui Partner',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Silakan lengkapi informasi partner distributor',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF4C6FFF),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF9CA3AF),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool required, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? prefixText,
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
            if (required)
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
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: required
              ? (v) => v == null || v.isEmpty ? '$label harus diisi' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Consumer<PartnerProvider>(
      builder: (context, provider, _) {
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
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _save,
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
                    : Text(
                        widget.partner == null
                            ? 'Simpan Partner'
                            : 'Simpan Perubahan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      if (auth.token == null) return;

      final partner = PartnerData(
        id: widget.partner?.id ?? 0,
        code: _codeController.text,
        name: _nameController.text,
        address: _addressController.text,
        city: _cityController.text,
        province: _provinceController.text,
        postalCode: _postalCodeController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        npwp: _npwpController.text,
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0,
        paymentTermDays: int.tryParse(_paymentTermController.text) ?? 0,
        isActive: _isActive,
        notes: _notesController.text,
      );

      bool success;
      if (widget.partner == null) {
        success = await context.read<PartnerProvider>().addPartner(
          auth.token!,
          partner,
        );
      } else {
        success = await context.read<PartnerProvider>().updatePartner(
          auth.token!,
          partner,
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Partner berhasil ${widget.partner == null ? "ditambahkan" : "diperbarui"}',
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<PartnerProvider>().errorMessage ??
                  'Gagal menyimpan partner',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

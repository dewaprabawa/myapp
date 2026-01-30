import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isEditingProfile = false;
  bool _isEditingPassword = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<AuthProvider>().fetchUserProfile();
      if (!mounted) return;
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_profileFormKey.currentState!.validate()) {
      final success = await context.read<AuthProvider>().updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
      );

      if (mounted) {
        if (success) {
          setState(() => _isEditingProfile = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Profil berhasil diperbarui'
                  : context.read<AuthProvider>().errorMessage ??
                        'Gagal memperbarui profil',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      final success = await context.read<AuthProvider>().updatePassword(
        currentPassword: _currentPasswordController.text,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (mounted) {
        if (success) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          setState(() => _isEditingPassword = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Password berhasil diperbarui'
                  : context.read<AuthProvider>().errorMessage ??
                        'Gagal memperbarui password',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil Saya',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola informasi profil dan keamanan akun',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileCard(authProvider),
            const SizedBox(height: 24),
            _buildPasswordCard(authProvider),
            const SizedBox(height: 24),
            _buildLogoutCard(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: ListTile(
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Apakah Anda yakin ingin keluar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
          if (confirm == true && mounted) {
            await context.read<AuthProvider>().logout();
            if (mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEF4444),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProfileCard(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Form(
        key: _profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Informasi Profil',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingProfile = !_isEditingProfile;
                      if (!_isEditingProfile) {
                        // Reset controllers to current user data if cancelled
                        final user = context.read<AuthProvider>().user;
                        if (user != null) {
                          _nameController.text = user.name;
                          _phoneController.text = user.phone ?? '';
                        }
                      }
                    });
                  },
                  icon: Icon(
                    _isEditingProfile
                        ? Icons.close_rounded
                        : Icons.edit_rounded,
                    size: 18,
                    color: _isEditingProfile
                        ? Colors.red
                        : const Color(0xFF4C6FFF),
                  ),
                  label: Text(
                    _isEditingProfile ? 'Batal' : 'Edit',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _isEditingProfile
                          ? Colors.red
                          : const Color(0xFF4C6FFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Nama'),
            _isEditingProfile
                ? _buildTextFormField(
                    controller: _nameController,
                    hint: 'Nama Lengkap',
                    validator: (v) =>
                        v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  )
                : _buildReadOnlyText(_nameController.text),
            const SizedBox(height: 16),
            _buildFieldLabel('Email'),
            _buildReadOnlyText(_emailController.text),
            const SizedBox(height: 16),
            _buildFieldLabel('Telepon'),
            _isEditingProfile
                ? _buildTextFormField(
                    controller: _phoneController,
                    hint: 'Nomor Telepon',
                    keyboardType: TextInputType.phone,
                  )
                : _buildReadOnlyText(
                    _phoneController.text.isEmpty ? '-' : _phoneController.text,
                  ),
            if (_isEditingProfile) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading ? null : _updateProfile,
                  icon: authProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    'Simpan Perubahan',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C6FFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordCard(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ubah Password',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingPassword = !_isEditingPassword;
                      if (!_isEditingPassword) {
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      }
                    });
                  },
                  icon: Icon(
                    _isEditingPassword
                        ? Icons.close_rounded
                        : Icons.lock_open_rounded,
                    size: 18,
                    color: _isEditingPassword
                        ? Colors.red
                        : const Color(0xFFF59E0B),
                  ),
                  label: Text(
                    _isEditingPassword ? 'Batal' : 'Ubah',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _isEditingPassword
                          ? Colors.red
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!_isEditingPassword) ...[
              _buildFieldLabel('Password'),
              _buildReadOnlyText('••••••••••••'),
            ] else ...[
              _buildFieldLabel('Password Saat Ini'),
              _buildTextFormField(
                controller: _currentPasswordController,
                hint: 'Masukkan password saat ini',
                obscureText: _obscureCurrent,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrent
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Password saat ini diperlukan' : null,
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Password Baru'),
              _buildTextFormField(
                controller: _newPasswordController,
                hint: 'Masukkan password baru',
                obscureText: _obscureNew,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
                validator: (v) =>
                    v!.length < 6 ? 'Password minimal 6 karakter' : null,
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Konfirmasi Password Baru'),
              _buildTextFormField(
                controller: _confirmPasswordController,
                hint: 'Konfirmasi password baru',
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (v) {
                  if (v != _newPasswordController.text) {
                    return 'Konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading ? null : _updatePassword,
                  icon: authProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                        ),
                  label: Text(
                    'Ubah Password Sekarang',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: enabled ? Colors.black87 : Colors.grey,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4C6FFF)),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildReadOnlyText(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

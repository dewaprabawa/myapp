import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/master_data/sections/category_screen.dart';
import 'package:myapp/screens/master_data/sections/partner_distributor_screen.dart';
import 'package:myapp/screens/master_data/sections/unit_screen.dart';
import 'package:myapp/screens/widgets/notification_icons.dart';
import 'package:myapp/shared/base_color.dart';
import 'package:myapp/screens/master_data/sections/product_screen.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

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
            _buildMenuList(context),
            const SizedBox(height: 24),
            _buildExportSection(),
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
          'Master Data',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kelola informasi dasar sistem inventaris Anda.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.inventory_2_rounded,
          iconColor: const Color(0xFF4C6FFF),
          iconBgColor: const Color(0xFFE8ECFF),
          title: 'Produk',
          subtitle: 'Kelola katalog dan stok produk.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.label_rounded,
          iconColor: const Color(0xFF8B5CF6),
          iconBgColor: const Color(0xFFF3E8FF),
          title: 'Kategori',
          subtitle: 'Klasifikasikan produk ke grup tertentu.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.straighten_rounded,
          iconColor: const Color(0xFF10B981),
          iconBgColor: const Color(0xFFD1FAE5),
          title: 'Satuan',
          subtitle: 'Atur unit pengukuran (Pcs, Box, Kg).',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UnitScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.people_rounded,
          iconColor: const Color(0xFFF59E0B),
          iconBgColor: const Color(0xFFFEF3C7),
          title: 'Partner',
          subtitle: 'Daftar supplier dan pelanggan tetap.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PartnerDistributorScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF9CA3AF),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE8ECFF),
            const Color(0xFFE8ECFF).withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.storage_rounded,
              color: BaseColor.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Export Master Data',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cadangkan semua data master Anda ke CSV atau PDF untuk keperluan pelaporan eksternal.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: BaseColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mulai Export',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

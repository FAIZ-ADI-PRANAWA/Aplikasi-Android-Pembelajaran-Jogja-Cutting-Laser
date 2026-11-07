import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogja_cutting_laser/core/theme/app_colors.dart';

/// Layar untuk menampilkan profil pengembang aplikasi
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Mengunci orientasi layar ke mode portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background Image
            Positioned(
              bottom: 0, // Aligned to bottom
              right: -(screenWidth * 0.30), // Aligned to right
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/watermark_background.png', // The machine watermark
                  width: screenWidth * 0.8, // Adjusted width for better fit
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.precision_manufacturing,
                    size: screenWidth * 0.7, // 70% of screen width
                    color: const Color(0xFFEEEEEE),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Top Row with Back Button (invisible spacing if no back button desired, but good for UX)
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.primaryRed),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),

                    // Title Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardRed,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                          // 3D effect border
                          const BoxShadow(
                            color: AppColors.borderDarkRed,
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          )
                        ],
                      ),
                      child: Text(
                        'Profil pengembang',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Main Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.cardRed,
                        borderRadius: BorderRadius.circular(44),
                        border: Border.all(
                            color: AppColors.borderDarkRed, width: 6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Pengembangan Mobile Learning Berbasis\nAplikasi Android dikembangkan oleh:',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Profile Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/profile.png', // The original had this asset
                              width: 120,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 120,
                                height: 140,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.person,
                                    size: 80, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Details Table
                          _buildDetailRow(
                            "Nama",
                            "Yowana Lokendra",
                          ),
                          _buildDetailRow("NIM", "22105244004"),
                          _buildDetailRow("TTL", "Bekasi, 15 Desember 2003"),
                          _buildDetailRow(
                              "Program Studi", "S1 Teknologi Pendidikan"),
                          _buildDetailRow("Fakultas", "Ilmu Pendidikan"),
                          _buildDetailRow("Motto",
                              "Setinggi apapun ilmu dapat digapai, akan menjadi kosong jika tidak berguna bagi orang lain."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pembantu untuk menampilkan baris detail informasi pengembang (Label : Nilai)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          Text(
            " : ",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

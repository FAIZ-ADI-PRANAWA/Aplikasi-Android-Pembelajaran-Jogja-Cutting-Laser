import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'quiz_screen.dart';

/// Layar untuk menampilkan hasil skor akhir setelah kuis selesai
class QuizResultScreen extends StatelessWidget {
  final int score;
  final VoidCallback? onRetry;

  const QuizResultScreen({super.key, required this.score, this.onRetry});

  Widget _build3DButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE12A20),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            const BoxShadow(
              color: Color(0xFFA51B14),
              offset: Offset(0, 6),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            shadows: [
              const Shadow(
                color: Colors.black26,
                offset: Offset(1, 2),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk mengatur penempatan elemen (seperti watermark)
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button on result screen
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const SizedBox.expand(),
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Skor Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE12A20),
                        shape: BoxShape.circle,
                        boxShadow: [
                          const BoxShadow(
                            color: Color(0xFFA51B14),
                            offset: Offset(0, 6),
                            blurRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        score.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Tombol untuk mengulangi mengerjakan kuis
                    _build3DButton('Ulangi', () {
                      if (onRetry != null) {
                        onRetry!();
                      } else {
                        Get.off(() => const QuizScreen(autoStart: true));
                      }
                    }),
                    // Tombol untuk kembali ke beranda aplikasi
                    _build3DButton('Kembali', () {
                      Get.offAllNamed('/home');
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogja_cutting_laser/core/theme/app_colors.dart';

/// Layar untuk memberikan umpan balik (feedback) apakah jawaban kuis pengguna benar atau salah
class QuizFeedbackScreen extends StatefulWidget {
  final bool isCorrect;

  const QuizFeedbackScreen({super.key, required this.isCorrect});

  @override
  State<QuizFeedbackScreen> createState() => _QuizFeedbackScreenState();
}

class _QuizFeedbackScreenState extends State<QuizFeedbackScreen> {
  @override
  void initState() {
    super.initState();
    // Menutup layar umpan balik secara otomatis setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  Widget _buildTitleBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD63333),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Color(0xFF9A1B1B),
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
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildTitleBox('Kuis'),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.65,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.cardRed,
                      borderRadius: BorderRadius.circular(44),
                      border:
                          Border.all(color: AppColors.borderDarkRed, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.isCorrect
                              ? 'Jawaban Anda\nBenar!'
                              : 'Jawaban Anda\nSalah',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Menampilkan ikon centang (benar) atau silang (salah)
                        if (widget.isCorrect)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF56D869),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 70,
                            ),
                          )
                        else
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5534B),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF8C2821),
                                  offset: Offset(0, 8),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

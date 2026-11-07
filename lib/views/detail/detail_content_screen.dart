import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Layar untuk menampilkan detail konten materi.
/// Menerima data melalui GetX arguments dan menampilkannya dalam bentuk halaman.
class DetailContentScreen extends StatefulWidget {
  const DetailContentScreen({super.key});

  @override
  State<DetailContentScreen> createState() => _DetailContentScreenState();
}

class _DetailContentScreenState extends State<DetailContentScreen> {
  late String title;
  late List<Map<String, dynamic>> contentData;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Mengunci orientasi layar agar selalu potrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? 'Detail Materi';
    contentData = args?['data'] ?? [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk digunakan dalam penataan tata letak
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryRed),
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Watermark
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
              child: Column(
                children: [
                  Expanded(
                    // PageView digunakan agar pengguna bisa menggeser konten (swipe) antar halaman
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: contentData.length,
                      itemBuilder: (context, index) {
                        final section = contentData[index];
                        return _buildPage(section);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: _buildPillButton('Kembali'),
                          )
                        else
                          const SizedBox(width: 110),
                        if (contentData.length > 1)
                          Row(
                            children: List.generate(
                              contentData.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                width: _currentPage == index ? 12.0 : 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? AppColors.primaryRed
                                      : Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            if (_currentPage < contentData.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Get.back();
                            }
                          },
                          child: _buildPillButton(
                            _currentPage < contentData.length - 1
                                ? 'Lanjutkan'
                                : 'Menu',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk membangun satu halaman konten (judul dan isi)
  Widget _buildPage(Map<String, dynamic> section) {
    final sectionTitle = section['title'] as String;
    final content = section['content'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Title Box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.cardRed,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                // 3D depth at the bottom
                const BoxShadow(
                  color: AppColors.borderDarkRed,
                  offset: Offset(0, 4),
                  blurRadius: 0,
                ),
                // Soft drop shadow below the 3D depth
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              sectionTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
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
          const SizedBox(height: 24),
          // Content Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardRed,
              borderRadius: BorderRadius.circular(44),
              border: Border.all(color: AppColors.borderDarkRed, width: 6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.containsKey('subtitle')) ...[
                  Text(
                    section['subtitle'] as String,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (content != null) _buildContent(content),
                if (section.containsKey('bullets'))
                  ...(section['bullets'] as List).map((bullet) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bullet.toString(),
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk menyusun widget konten berdasarkan tipe datanya (Teks atau List)
  Widget _buildContent(dynamic content) {
    if (content is String) {
      return Text(
        content,
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          height: 1.5,
        ),
      );
    } else if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.asMap().entries.map((entry) {
          int index = entry.key;
          dynamic item = entry.value;

          if (item is Map) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (item['bullets'] != null)
                    ...(item['bullets'] as List).map((bullet) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bullet.toString(),
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          } else {
            String text = item.toString();
            if (text.contains('|')) {
              final parts = text.split('|');
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        parts[0],
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      parts[1],
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPillButton(String text) {
    return Container(
      width: 110,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE84C3D), Color(0xFFC0392B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: Color(0xFFA51B14),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

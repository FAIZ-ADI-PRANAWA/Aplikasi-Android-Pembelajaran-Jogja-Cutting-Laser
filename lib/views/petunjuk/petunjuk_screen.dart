import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PetunjukScreen extends StatefulWidget {
  const PetunjukScreen({super.key});

  @override
  State<PetunjukScreen> createState() => _PetunjukScreenState();
}

class _PetunjukScreenState extends State<PetunjukScreen> {
  late String title;
  late List<Map<String, dynamic>> contentData;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? 'Petunjuk';
    contentData = args?['data'] ?? [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: -(screenWidth * 0.30),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/watermark_background.png',
                  width: screenWidth * 0.8,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.precision_manufacturing,
                    size: screenWidth * 0.7,
                    color: const Color(0xFFEEEEEE),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                width: _currentPage == index ? 12.0 : 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? Colors.black87
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
                            _currentPage < contentData.length - 1 ? 'Lanjutkan' : 'Menu',
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

  Widget _buildPage(Map<String, dynamic> section) {
    final sectionTitle = section['title'] as String;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Title Box (Grey)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                const BoxShadow(
                  color: Color(0xFFBDBDBD),
                  offset: Offset(0, 4),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              sectionTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Content Card (Grey)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(44),
              border: Border.all(color: const Color(0xFF9E9E9E), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                if (section['is_icon'] == true)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      section['icon_name'] == 'home' ? Icons.home : Icons.info,
                      color: Colors.white,
                      size: 45,
                    ),
                  )
                else if (section['image_path'] != null)
                  Image.asset(
                    section['image_path'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      size: 70,
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                if (section.containsKey('subtitle')) ...[
                  Text(
                    section['subtitle'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (section.containsKey('description')) ...[
                  Text(
                    section['description'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (section.containsKey('bullets'))
                  ...(section['bullets'] as List).map((bullet) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bullet.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
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

  Widget _buildPillButton(String text) {
    return Container(
      width: 110,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: Color(0xFFBDBDBD),
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
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

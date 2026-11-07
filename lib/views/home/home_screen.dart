import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// Layar utama (Beranda) aplikasi yang menampilkan menu utama dan kategori
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk layout yang responsif
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white, // In the UI, the background is white
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            // Logo image
            Image.asset(
              'assets/icons/icon_logo02.png',
              width: 60,
              height: 55,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image,
                size: 40,
                color: Colors.grey,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CV. JASA MULIA\nANKABUT',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/icon_logo01.png',
                        width: 60,
                        height: 55,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'JASA MULIA ANKABUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Jogja Cutting Laser',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Beranda',
                    onTap: () {
                      Get.back(); // close drawer
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.precision_manufacturing,
                    title: 'Materi Mesin Senfeng',
                    onTap: () {
                      Get.back();
                      Get.toNamed('/detail', arguments: {
                        'title': 'Materi Mesin Senfeng SF3015G',
                        'data': materiSenfengData,
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.health_and_safety,
                    title: 'Kesehatan & Keselamatan Kerja (K3)',
                    onTap: () {
                      Get.back();
                      Get.toNamed('/detail', arguments: {
                        'title': 'Kesehatan dan Keselamatan Kerja (K3)',
                        'data': k3Data,
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.play_circle_fill,
                    title: 'Video Tutorial',
                    onTap: () async {
                      Get.back();
                      await Get.toNamed('/video', arguments: {
                        'title':
                            'Video Tutorial\nOperasional Mesin Senfeng SF3015g',
                        'data': videoData,
                      });
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.quiz,
                    title: 'Kuis & Evaluasi',
                    onTap: () {
                      Get.back();
                      Get.toNamed('/quiz');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Profil Pengembang',
                    onTap: () {
                      Get.back();
                      Get.toNamed('/profile');
                    },
                  ),
                ],
              ),
            ),
            // Footer Version
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Versi 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Watermark Background
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Selamat Datang!',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700, // Extra bold
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Siap meningkatkan kompetensi hari ini?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Hero Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(16),
                        // Background overlapping circles for design
                        gradient: LinearGradient(
                          colors: [
                            AppColors.cardRed,
                            AppColors.cardRed.withValues(alpha: 0.8)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Decorative circles (right side)
                          Positioned(
                            left: -80,
                            top: -90,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Positioned(
                            right: -80,
                            top: -60,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Positioned(
                            right: -40,
                            bottom: -30,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 85,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/icons/icon_graduation.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Belajar\nOperasional Mesin\nPemotongan Logam',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed('/detail', arguments: {
                                          'title':
                                              'Materi Mesin Senfeng SF3015G',
                                          'data': materiSenfengData,
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Mulai Belajar',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward, size: 18),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kategori Materi',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700, // Extra bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Categories Row 1 (3 items)
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryCard(
                            title: 'Petunjuk\n',
                            imagePath: 'assets/icons/icon_petunjuk.png',
                            width: 75,
                            height: 75,
                            fallbackIcon: Icons.menu_book,
                            onTap: () {
                              Get.toNamed('/petunjuk', arguments: {
                                'title': 'Petunjuk',
                                'data': petunjukData,
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryCard(
                            title: 'Materi Mesin\nSenfeng SF3015G',
                            imagePath: 'assets/icons/icon_mesin.png',
                            width: 70,
                            height: 70, // Doesn't exist, will fallback
                            fallbackIcon: Icons.precision_manufacturing,
                            onTap: () {
                              Get.toNamed('/detail', arguments: {
                                'title': 'Materi Mesin Senfeng SF3015G',
                                'data': materiSenfengData,
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryCard(
                            title: 'Kesehatan dan\nKeselamatan Kerja (K3)',
                            imagePath: 'assets/icons/icon_K3.png',
                            fallbackIcon: Icons.health_and_safety,
                            iconColor: AppColors.primaryRed,
                            onTap: () {
                              Get.toNamed('/detail', arguments: {
                                'title': 'Kesehatan dan Keselamatan Kerja (K3)',
                                'data': k3Data,
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Categories Row 2 (3 items)
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryCard(
                            title: 'Video\nTutorial',
                            imagePath: 'assets/icons/icon_video_tutorial.png',
                            width: 60,
                            height: 60, // The provided monitor icon
                            onTap: () async {
                              await Get.toNamed('/video', arguments: {
                                'title':
                                    'Video Tutorial\nOperasional Mesin Senfeng SF3015g',
                                'data': videoData,
                              });
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryCard(
                            title: 'Kuis &\nEvaluasi',
                            imagePath: 'assets/icons/icon_kuis.png',
                            width: 55,
                            height:
                                55, // Will fallback if missing, but we copied it
                            fallbackIcon: Icons.quiz,
                            onTap: () {
                              Get.toNamed('/quiz');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pembantu untuk membuat kartu kategori materi pada beranda
  Widget _buildCategoryCard({
    required String title,
    String? imagePath,
    IconData? fallbackIcon,
    Color? iconColor,
    bool isWide = false,
    double? width,
    double? height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isWide ? 95 : 130, // Fixed height so they align well
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  imagePath != null
                      ? Image.asset(
                          imagePath,
                          width: width ?? 50,
                          height: height ?? 50,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              fallbackIcon ?? Icons.image,
                              size: 40,
                              color: iconColor ?? Colors.black,
                            );
                          },
                        )
                      : Icon(
                          fallbackIcon,
                          size: 40,
                          color: iconColor ?? Colors.black,
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700, // Extra bold
                        color: Colors.black,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: imagePath != null
                        ? Image.asset(
                            imagePath,
                            width: width,
                            height: height,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                fallbackIcon ?? Icons.image,
                                size: 40,
                                color: iconColor ?? Colors.black,
                              );
                            },
                          )
                        : Icon(
                            fallbackIcon,
                            size: 40,
                            color: iconColor ?? Colors.black,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700, // Extra bold
                        color: Colors.black,
                        height: 1.1),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// Layar untuk memutar video tutorial menggunakan YouTube Player
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  int _currentPage = 0;
  List<Map<String, dynamic>> _videoData = [];
  String _pageTitle = '';
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    // Mengizinkan semua orientasi agar otomatis rotasi saat HP dimiringkan
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _pageTitle = args['title'] ?? 'Video Tutorial';
      final rawData = args['data'] as List<dynamic>?;
      if (rawData != null && rawData.isNotEmpty) {
        _videoData = rawData.map((e) => e as Map<String, dynamic>).toList();
      } else {
        _videoData = videoData;
      }
    } else {
      _pageTitle = 'Video Tutorial\nOperasional Mesin Senfeng SF3015g';
      _videoData = videoData;
    }

    final initialId = _videoData.isNotEmpty
        ? (_videoData[0]['youtube_id'] as String)
        : 'QD-huCC7jI4';

    // Menggunakan satu controller tunggal agar tidak terjadi memory leak dan video tidak putus saat rotasi
    _controller = YoutubePlayerController(
      initialVideoId: initialId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // Kembalikan orientasi layar dan system UI ke mode portrait saat keluar
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _goToPage(int newIndex) {
    if (newIndex >= 0 && newIndex < _videoData.length) {
      setState(() {
        _currentPage = newIndex;
      });
      final newId = _videoData[newIndex]['youtube_id'] as String;
      _controller.load(newId);
    }
  }

  void _nextPage() {
    if (_currentPage < _videoData.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      Get.back();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoData.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentVideo = _videoData[_currentPage];
    final List<dynamic>? rawSop = currentVideo['sop'] as List<dynamic>?;
    final List<String>? sopItems = rawSop?.map((e) => e.toString()).toList();
    final String? sopTitle = currentVideo['sop_title'] as String?;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Mengembalikan kemampuan auto-rotate ketika keluar dari fullscreen
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primaryRed,
        bottomActions: const [
          SizedBox(width: 14.0),
          CurrentPosition(),
          SizedBox(width: 8.0),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: AppColors.primaryRed,
              handleColor: AppColors.primaryRed,
            ),
          ),
          RemainingDuration(),
          PlaybackSpeedButton(),
          FullScreenButton(),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
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
                // Watermark latar belakang
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
                      // Area Konten yang dapat di-scroll
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity != null) {
                              if (details.primaryVelocity! < -300) {
                                _nextPage(); // Geser ke kiri -> lanjut
                              } else if (details.primaryVelocity! > 300) {
                                _previousPage(); // Geser ke kanan -> kembali
                              }
                            }
                          },
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                // Kotak Judul Atas
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardRed,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      const BoxShadow(
                                        color: AppColors.borderDarkRed,
                                        offset: Offset(0, 4),
                                        blurRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _pageTitle,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Kartu Konten Merah
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardRed,
                                    borderRadius: BorderRadius.circular(44),
                                    border: Border.all(
                                        color: AppColors.borderDarkRed,
                                        width: 6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Judul Tahapan (Pra-Produksi / Produksi / Pasca-Produksi)
                                      Center(
                                        child: Text(
                                          currentVideo['title'] as String,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),

                                      // Pemutar Video (Mempertahankan instance yang sama dari YoutubePlayerBuilder)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: player,
                                      ),

                                      // Bagian SOP di bawah video (Sesuai Gambar Referensi)
                                      if (sopItems != null &&
                                          sopItems.isNotEmpty) ...[
                                        const SizedBox(height: 24),
                                        if (sopTitle != null)
                                          Text(
                                            sopTitle,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        const SizedBox(height: 14),
                                        ...List.generate(sopItems.length, (i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${i + 1}. ',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.5,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    sopItems[i],
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Tombol Navigasi Bawah (Kembali, Titik Indikator, Lanjutkan)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              GestureDetector(
                                onTap: _previousPage,
                                child: _buildPillButton('Kembali'),
                              )
                            else
                              const SizedBox(width: 110),
                            if (_videoData.length > 1)
                              Row(
                                children: List.generate(
                                  _videoData.length,
                                  (idx) => GestureDetector(
                                    onTap: () => _goToPage(idx),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      width: _currentPage == idx ? 12.0 : 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        color: _currentPage == idx
                                            ? AppColors.primaryRed
                                            : Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox(),
                            GestureDetector(
                              onTap: _nextPage,
                              child: _buildPillButton(
                                _currentPage < _videoData.length - 1
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
      },
    );
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

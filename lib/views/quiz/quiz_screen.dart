import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import 'quiz_result_screen.dart';
import 'quiz_feedback_screen.dart';

/// Layar utama kuis tempat pengguna menjawab pertanyaan
class QuizScreen extends StatefulWidget {
  final bool autoStart;

  const QuizScreen({super.key, this.autoStart = false});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late bool _hasStarted;
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _hasStarted = widget.autoStart;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _resetQuiz() {
    setState(() {
      _hasStarted = false;
      _currentIndex = 0;
      _score = 0;
      _isAnswered = false;
    });
  }

  /// Menangani logika saat pengguna memilih jawaban (mengecek benar/salah dan menghitung skor)
  void _handleAnswer(int selectedIndex) {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
    });

    bool isCorrect =
        selectedIndex == quizData[_currentIndex]['jawaban_benar_index'];

    if (isCorrect) {
      _score += (100 / quizData.length).round();
    }

    Get.to(() => QuizFeedbackScreen(isCorrect: isCorrect),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300))
        ?.then((_) {
      if (_currentIndex < quizData.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
        });
      } else {
        Get.off(() => QuizResultScreen(
              score: _score,
              onRetry: () {
                Get.off(() => const QuizScreen(autoStart: true));
              },
            ));
      }
    });
  }

  Widget _buildTitleBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardRed,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: AppColors.borderDarkRed,
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
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          shadows: [
            const Shadow(
              color: Colors.black26,
              offset: Offset(1, 2),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            const BoxShadow(
              color: Color(0xFFBDBDBD),
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(String text) {
    return Container(
      width: 190,
      height: 55,
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
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final questionData = quizData[_currentIndex];
    final options = questionData['opsi'] as List<String>;

    return PopScope(
      canPop: !_hasStarted,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_hasStarted) {
          _resetQuiz();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryRed),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_hasStarted) {
                _resetQuiz();
              } else {
                Get.back();
              }
            },
          ),
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
              child: _hasStarted
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildTitleBox('Kuis'),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.cardRed,
                              borderRadius: BorderRadius.circular(44),
                              border: Border.all(
                                  color: AppColors.borderDarkRed, width: 6),
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
                                Text(
                                  'Soal:',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${_currentIndex + 1}. ${questionData['pertanyaan']}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ...List.generate(options.length, (index) {
                                  return _buildOptionButton(
                                    options[index],
                                    _isAnswered
                                        ? () {}
                                        : () => _handleAnswer(index),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildTitleBox('Kuis'),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.50,
                            ),
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: AppColors.cardRed,
                              borderRadius: BorderRadius.circular(44),
                              border: Border.all(
                                  color: AppColors.borderDarkRed, width: 6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Kuis ini bertujuan untuk mengukur tingkat pemahaman staf terhadap materi operasional mesin pemotongan logam Senfeng SF3015G. i. Bacalah setiap pertanyaan dengan cermat dan pilihlah jawaban yang paling tepat berdasarkan materi yang telah dipelajari. Silahkan klik mulai untuk mulai mengerjakan',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 47),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _hasStarted = true;
                                      });
                                    },
                                    child: _buildPillButton('Mulai'),
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
      ),
    );
  }
}

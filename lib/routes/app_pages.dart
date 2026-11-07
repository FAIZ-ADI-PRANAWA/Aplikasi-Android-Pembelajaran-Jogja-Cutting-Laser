import 'package:get/get.dart';
import '../views/home/home_screen.dart';
import '../views/detail/detail_content_screen.dart';
import '../views/video/video_player_screen.dart';
import '../views/quiz/quiz_screen.dart';
import '../views/profile/profile_screen.dart';
import '../views/petunjuk/petunjuk_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => const HomeScreen()),
    GetPage(name: Routes.DETAIL, page: () => const DetailContentScreen()),
    GetPage(name: Routes.VIDEO, page: () => const VideoPlayerScreen()),
    GetPage(name: Routes.QUIZ, page: () => const QuizScreen()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
    GetPage(name: Routes.PETUNJUK, page: () => const PetunjukScreen()),
  ];
}

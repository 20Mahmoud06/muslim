import 'package:flutter/material.dart';
import 'package:muslim/features/home/screens/home_screen.dart';
import 'package:muslim/features/qibla/screens/qibla_screen.dart';
import 'package:muslim/features/quran/screens/quran_screen.dart';
import 'package:muslim/features/tasbih/screens/tasbih_screen.dart';
import '../../features/allah_names/screens/allah_names_screen.dart';
import '../../features/azkar/screens/azkar_categories_screen.dart';
import '../../features/hadith/screens/hadith_screen.dart';
import '../../features/hijri_calendar/screens/hijri_calendar_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/prayer_times/screens/prayer_times_detail_screen.dart';
import '../../splash_screen.dart';
import 'route_names.dart';
import 'package:muslim/features/notifications/screens/notification_settings_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.quran:
        return MaterialPageRoute(builder: (_) => const QuranScreen());
      case RouteNames.qiblah:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case RouteNames.azkar:
        return MaterialPageRoute(builder: (_) => const AzkarCategoriesScreen());
      case RouteNames.allahNames:
        return MaterialPageRoute(builder: (_) => const AllahNamesScreen());
      case RouteNames.hijriCalendar:
        return MaterialPageRoute(builder: (_) => const HijriCalendarScreen());
      case RouteNames.prayerTimesDetail:
        return MaterialPageRoute(builder: (_) => const PrayerTimesDetailScreen(),);
      case RouteNames.tasbih:
        return MaterialPageRoute(builder: (_) => const TasbihScreen());
      case RouteNames.hadith:
        return MaterialPageRoute(builder: (_) => const HadithScreen());
      case RouteNames.notificationSettings:
        return MaterialPageRoute(builder: (_) => const NotificationSettingsScreen());

      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

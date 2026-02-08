import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_library/quran_library.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/app_router.dart';
import 'core/routes/route_names.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:muslim/features/notifications/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  tz.initializeTimeZones();
  await NotificationService.initialize();
  print('✅ تم تهيئة خدمة الإشعارات');

  // التحقق من حالة الـ onboarding
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  // إذا الـ onboarding تم، نجدول التذكيرات اليومية
  if (onboardingDone) {
    final notificationPermission = prefs.getBool('notification_permission') ?? false;
    if (notificationPermission) {
      await NotificationService.scheduleDailyReminders();
      print('✅ تم جدولة التذكيرات اليومية');
    }
  }

  await QuranLibrary.init(
    userBookmarks: {
      0: [BookmarkModel(id: 0, colorCode: Colors.green.value, name: "أخضر")],
      1: [BookmarkModel(id: 1, colorCode: Colors.yellow.value, name: "أصفر")],
      2: [BookmarkModel(id: 2, colorCode: Colors.red.value, name: "أحمر")],
    },
  );

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'cairo',
          ),
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: RouteNames.splash, // ← ابدأ بالـ splash
        );
      },
    );
  }
}
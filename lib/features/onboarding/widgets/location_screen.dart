import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:muslim/features/onboarding/widgets/custom_onboarding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../../../shared/custom_text.dart';
import '../../notifications/services/notification_service.dart';
import '../../prayer_times/services/prayer_times_service.dart';

class LocationScreen extends StatefulWidget {
  final PageController pageController;

  const LocationScreen({super.key, required this.pageController});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isProcessing = false;

  void _showPermissionSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: message, textColor: Colors.white),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSettingsDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: CustomText(
          text: 'السماح بـ $permissionName',
          fontWeight: FontWeight.w600,
          textColor: AppColors.primaryColor,
        ),
        content: CustomText(
          text: 'تم رفض الإذن بشكل دائم. يرجى تفعيله من إعدادات التطبيق للحصول على أوقات الصلاة الدقيقة.',
          textColor: AppColors.grey,
          height: 1.5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // إكمال حتى بدون موقع
              _completeOnboarding();
            },
            child: CustomText(
              text: 'تخطي',
              textColor: AppColors.grey,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();

              // التحقق بعد العودة من الإعدادات
              if (mounted) {
                await Future.delayed(const Duration(milliseconds: 500));
                final newStatus = await Permission.location.status;
                if (newStatus.isGranted) {
                  await _completeOnboarding();
                }
              }
            },
            child: CustomText(
              text: 'الإعدادات',
              textColor: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. حفظ أن الـ onboarding تم إكماله
      await prefs.setBool('onboarding_done', true);
      print('✅ تم حفظ حالة الـ onboarding');

      // 2. محاولة الحصول على الموقع وحساب مواقيت الصلاة
      final position = await PrayerTimesService.getCurrentLocation();
      if (position != null) {
        // حساب مواقيت الصلاة
        final prayerTimes = await PrayerTimesService.calculatePrayerTimes(
          latitude: position.latitude,
          longitude: position.longitude,
          scheduleNotifications: true, // جدولة إشعارات الصلاة
        );

        if (prayerTimes != null) {
          print('✅ تم حساب مواقيت الصلاة وجدولة الإشعارات');
        }

        // حفظ الموقع
        final city = await PrayerTimesService.getCityName(
          position.latitude,
          position.longitude,
        );
        await PrayerTimesService.saveLocation(
          position.latitude,
          position.longitude,
          city ?? 'موقعك الحالي',
        );
      } else {
        print('⚠️ لم يتم الحصول على الموقع');
      }

      // 3. جدولة التذكيرات اليومية (الجمعة، سورة الملك، الورد)
      final dailyRemindersEnabled = prefs.getBool('notification_permission') ?? false;
      if (dailyRemindersEnabled) {
        await NotificationService.scheduleDailyReminders();
        print('✅ تم جدولة التذكيرات اليومية');
      }

      // 4. الانتقال للصفحة الرئيسية
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    } catch (e) {
      print('خطأ في إكمال الـ onboarding: $e');

      // حتى لو حصل خطأ، ننتقل للصفحة الرئيسية
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_done', true);
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomOnboarding(
      imageWidget: Lottie.asset(
        'assets/animations/location.json',
        height: 250.h,
        fit: BoxFit.cover,
      ),
      topPadding: 120,
      imageHeight: 190,
      titleTopPadding: 38,
      descriptionTopPadding: 20,
      buttonTopPadding: 55,
      bottomPadding: 0,
      title: 'فعّل الموقع',
      description:
      'اسمح للتطبيق بتحديد موقعك للحصول على أوقات الصلاة الدقيقة وجدولة الإشعارات تلقائياً.',
      buttonText: _isProcessing ? 'جاري التحميل...' : 'السماح',
      onButtonPressed: _isProcessing
          ? null
          : () async {
        final status = await Permission.location.request();

        if (status.isGranted || status.isLimited) {
          await _completeOnboarding();
        } else if (status.isPermanentlyDenied) {
          _showSettingsDialog('الموقع');
        } else {
          _showPermissionSnackBar('يرجى السماح بمشاركة الموقع');
        }
      },
      showNextButton: false,
    );
  }
}
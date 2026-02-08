import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:muslim/features/onboarding/widgets/custom_onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class NotificationScreen extends StatefulWidget {
  final PageController pageController;

  const NotificationScreen({super.key, required this.pageController});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isRequesting = false;

  void _showPermissionSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: message, textColor: Colors.white),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    if (_isRequesting) return;

    setState(() => _isRequesting = true);

    try {
      // طلب الإذن من Awesome Notifications
      bool isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();

      if (isAllowed) {
        // حفظ أن الإذن تم منحه
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notification_permission', true);

        _showPermissionSnackBar('تم تفعيل الإشعارات بنجاح ✅');

        // الانتقال للصفحة التالية
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          widget.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _showPermissionSnackBar('يرجى السماح بالإشعارات من إعدادات التطبيق');

        // إعطاء المستخدم خيار فتح الإعدادات
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _showSettingsDialog();
        }
      }
    } catch (e) {
      print('خطأ في طلب إذن الإشعارات: $e');
      _showPermissionSnackBar('حدث خطأ، يرجى المحاولة مرة أخرى');
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: CustomText(
          text: 'تفعيل الإشعارات',
          fontWeight: FontWeight.w600,
          textColor: AppColors.primaryColor,
        ),
        content: CustomText(
          text: 'للحصول على إشعارات مواقيت الصلاة والتذكيرات اليومية، يرجى تفعيل الإشعارات من إعدادات التطبيق.',
          textColor: AppColors.grey,
          height: 1.5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // الانتقال للصفحة التالية حتى لو لم يفعّل
              widget.pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: CustomText(
              text: 'تخطي',
              textColor: AppColors.grey,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // فتح إعدادات التطبيق
              await AwesomeNotifications().showNotificationConfigPage();

              // التحقق بعد العودة
              if (mounted) {
                await Future.delayed(const Duration(milliseconds: 500));
                bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

                if (isAllowed) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('notification_permission', true);

                  _showPermissionSnackBar('تم تفعيل الإشعارات بنجاح ✅');

                  await Future.delayed(const Duration(milliseconds: 500));
                  if (mounted) {
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
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

  @override
  Widget build(BuildContext context) {
    return CustomOnboarding(
      imageWidget: Lottie.asset(
        'assets/animations/notification.json',
        height: 180.h,
        fit: BoxFit.contain,
      ),
      topPadding: 40,
      imageHeight: 230,
      titleTopPadding: 0,
      descriptionTopPadding: 20,
      buttonTopPadding: 57,
      title: 'فعّل الإشعارات',
      description:
      'اسمح بتلقي تنبيهات الأذان في أوقات الصلاة والتذكيرات اليومية بدقة عالية.',
      buttonText: _isRequesting ? 'جاري الطلب...' : 'السماح',
      onButtonPressed: _isRequesting
          ? null
          : () async {
        await _requestNotificationPermission();
      },
    );
  }
}
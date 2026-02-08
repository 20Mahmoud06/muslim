import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/notifications/cubit/notifications_cubit.dart';
import 'package:muslim/features/notifications/cubit/notifications_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../services/notification_service.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_section_header.dart';
import '../widgets/xiaomi_permission_dialog.dart';
import '../constants/notification_constants.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationSettingsCubit()..loadSettings(),
      child: const _NotificationSettingsView(),
    );
  }
}

class _NotificationSettingsView extends StatefulWidget {
  const _NotificationSettingsView();

  @override
  State<_NotificationSettingsView> createState() =>
      __NotificationSettingsViewState();
}

class __NotificationSettingsViewState extends State<_NotificationSettingsView> {
  @override
  void initState() {
    super.initState();
    _checkAndShowXiaomiDialog();
  }

  Future<void> _checkAndShowXiaomiDialog() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final hasShownDialog =
        prefs.getBool(NotificationConstants.xiaomiDialogShownKey) ?? false;

    if (!hasShownDialog && mounted) {
      showDialog(
        context: context,
        builder: (context) => const XiaomiPermissionDialog(),
      );
      await prefs.setBool(NotificationConstants.xiaomiDialogShownKey, true);
    }
  }

  Future<void> _showScheduledNotifications(BuildContext context) async {
    final scheduled = await NotificationService.getScheduledNotifications();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: 'الإشعارات المجدولة (${scheduled.length})',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryColor,
        ),
        content: scheduled.isEmpty
            ? CustomText(
          text: 'لا توجد إشعارات مجدولة',
          fontSize: 14.sp,
          textColor: Colors.grey,
        )
            : SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: scheduled.length,
            itemBuilder: (context, index) {
              final notif = scheduled[index];
              return ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: AppColors.primaryColor,
                ),
                title: CustomText(
                  text: notif.content?.title ?? 'بدون عنوان',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: CustomText(
                  text: notif.content?.body ?? '',
                  fontSize: 12.sp,
                  textColor: Colors.grey,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(
              text: 'إغلاق',
              fontSize: 14.sp,
              textColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: CustomText(
          text: 'إعدادات الإشعارات',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<NotificationSettingsCubit, NotificationSettingsState>(
        listener: (context, state) {
          if (state is NotificationSettingsSuccess) {
            _showSnackBar(context, state.message);
          } else if (state is NotificationSettingsError) {
            _showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotificationSettingsLoading ||
              state is NotificationSettingsInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (state is NotificationSettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: state.message,
                    fontSize: 16.sp,
                    textColor: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => context.read<NotificationSettingsCubit>().loadSettings(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is! NotificationSettingsLoaded) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // معلومات
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text:
                        'الإشعارات تعمل حتى لو كان التطبيق مغلقاً\nتتجدد تلقائياً كل يوم',
                        fontSize: 14.sp,
                        textColor: AppColors.secondaryColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // إشعارات الصلاة
              const NotificationSectionHeader(title: 'إشعارات الصلاة'),
              SizedBox(height: 12.h),
              NotificationCard(
                icon: Icons.mosque,
                title: 'إشعارات مواقيت الصلاة',
                subtitle: 'إشعار عند كل صلاة من الصلوات الخمس',
                value: state.prayerNotificationsEnabled,
                onChanged: (value) => context
                    .read<NotificationSettingsCubit>()
                    .togglePrayerNotifications(value),
                color: AppColors.primaryColor,
              ),

              SizedBox(height: 24.h),

              // التذكيرات اليومية
              const NotificationSectionHeader(title: 'التذكيرات اليومية'),
              SizedBox(height: 12.h),

              NotificationCard(
                icon: Icons.menu_book_rounded,
                title: 'سورة الكهف',
                subtitle: 'كل يوم جمعة - 10:00 صباحاً',
                description:
                'من قرأ سورة الكهف يوم الجمعة أضاء له من النور ما بين الجمعتين',
                value: state.fridayKahfEnabled,
                onChanged: (value) => context
                    .read<NotificationSettingsCubit>()
                    .toggleFridayKahf(value),
                color: Colors.green,
              ),

              SizedBox(height: 16.h),

              NotificationCard(
                icon: Icons.nightlight_round,
                title: 'سورة الملك',
                subtitle: 'كل يوم - 11:00 مساءً',
                description: 'سورة الملك تنجي من عذاب القبر',
                value: state.nightMulkEnabled,
                onChanged: (value) => context
                    .read<NotificationSettingsCubit>()
                    .toggleNightMulk(value),
                color: Colors.indigo,
              ),

              SizedBox(height: 16.h),

              NotificationCard(
                icon: Icons.auto_awesome,
                title: 'الورد اليومي والأذكار',
                subtitle: 'كل يوم - 1:00 ظهراً',
                description: 'واذكر ربك في نفسك تضرعاً وخيفة',
                value: state.dailyWirdEnabled,
                onChanged: (value) => context
                    .read<NotificationSettingsCubit>()
                    .toggleDailyWird(value),
                color: Colors.orange,
              ),

              SizedBox(height: 32.h),

              // أدوات مساعدة
              const NotificationSectionHeader(title: 'أدوات مساعدة'),
              SizedBox(height: 12.h),

              // زر عرض الإشعارات المجدولة
              OutlinedButton.icon(
                onPressed: () => _showScheduledNotifications(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 2),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.list_alt,
                    color: AppColors.primaryColor, size: 20.sp),
                label: CustomText(
                  text: 'عرض الإشعارات المجدولة',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryColor,
                ),
              ),

              SizedBox(height: 12.h),

              // زر المساعدة لـ Xiaomi
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const XiaomiPermissionDialog(),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange, width: 2),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.help_outline,
                    color: Colors.orange, size: 20.sp),
                label: CustomText(
                  text: 'مساعدة لمستخدمي Xiaomi',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.orange,
                ),
              ),

              SizedBox(height: 32.h),
            ],
          );
        },
      ),
    );
  }
}
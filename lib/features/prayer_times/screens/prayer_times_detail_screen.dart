import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../../notifications/screens/notification_settings_screen.dart';
import '../cubit/prayer_times_cubit.dart';
import '../cubit/prayer_times_state.dart';
import '../widgets/prayer_detail_app_bar.dart';
import '../widgets/city_location_card.dart';
import '../widgets/date_display_card.dart';
import '../widgets/prayer_row_item.dart';
import '../widgets/error_state_widget.dart';

class PrayerTimesDetailScreen extends StatelessWidget {
  const PrayerTimesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit()..loadPrayerTimes(),
      child: const _PrayerTimesDetailView(),
    );
  }
}

class _PrayerTimesDetailView extends StatelessWidget {
  const _PrayerTimesDetailView();

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PrayerDetailAppBar(
        onSettingsTap: () => _navigateToSettings(context),
      ),
      body: BlocConsumer<PrayerTimesCubit, PrayerTimesState>(
        listener: (context, state) {
          if (state is PrayerTimesNotificationUpdated) {
            _showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is PrayerTimesLoading || state is PrayerTimesInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor),
                  SizedBox(height: 20.h),
                  CustomText(
                    text: 'جاري تحميل المواقيت...',
                    fontSize: 16.sp,
                    textColor: AppColors.grey,
                  ),
                ],
              ),
            );
          }

          if (state is PrayerTimesError) {
            return ErrorStateWidget(
              onRetry: () => context.read<PrayerTimesCubit>().loadPrayerTimes(),
            );
          }

          if (state is! PrayerTimesLoaded) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<PrayerTimesCubit>().refreshPrayerTimes(),
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CityLocationCard(cityName: state.cityName),
                  SizedBox(height: 16.h),
                  const DateDisplayCard(),
                  SizedBox(height: 20.h),
                  _buildPrayersList(context, state),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayersList(BuildContext context, PrayerTimesLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            PrayerRowItem(
              prayerKey: 'fajr',
              prayerName: 'الفجر',
              prayerTime: state.prayerTimes.fajr,
              icon: Icons.wb_twilight_outlined,
              isCurrent: state.prayerTimes.isCurrentPrayer('fajr'),
              isNext: state.prayerTimes.isNextPrayer('fajr'),
              isNotificationEnabled: state.notificationSettings['fajr'] ?? true,
              onNotificationToggle: (enabled) {
                context.read<PrayerTimesCubit>().togglePrayerNotification('fajr', enabled);
              },
            ),
            Divider(height: 1, color: AppColors.lightGrey.withOpacity(0.3)),
            PrayerRowItem(
              prayerKey: 'dhuhr',
              prayerName: 'الظهر',
              prayerTime: state.prayerTimes.dhuhr,
              icon: Icons.wb_sunny_outlined,
              isCurrent: state.prayerTimes.isCurrentPrayer('dhuhr'),
              isNext: state.prayerTimes.isNextPrayer('dhuhr'),
              isNotificationEnabled: state.notificationSettings['dhuhr'] ?? true,
              onNotificationToggle: (enabled) {
                context.read<PrayerTimesCubit>().togglePrayerNotification('dhuhr', enabled);
              },
            ),
            Divider(height: 1, color: AppColors.lightGrey.withOpacity(0.3)),
            PrayerRowItem(
              prayerKey: 'asr',
              prayerName: 'العصر',
              prayerTime: state.prayerTimes.asr,
              icon: Icons.wb_sunny,
              isCurrent: state.prayerTimes.isCurrentPrayer('asr'),
              isNext: state.prayerTimes.isNextPrayer('asr'),
              isNotificationEnabled: state.notificationSettings['asr'] ?? true,
              onNotificationToggle: (enabled) {
                context.read<PrayerTimesCubit>().togglePrayerNotification('asr', enabled);
              },
            ),
            Divider(height: 1, color: AppColors.lightGrey.withOpacity(0.3)),
            PrayerRowItem(
              prayerKey: 'maghrib',
              prayerName: 'المغرب',
              prayerTime: state.prayerTimes.maghrib,
              icon: Icons.wb_twilight,
              isCurrent: state.prayerTimes.isCurrentPrayer('maghrib'),
              isNext: state.prayerTimes.isNextPrayer('maghrib'),
              isNotificationEnabled: state.notificationSettings['maghrib'] ?? true,
              onNotificationToggle: (enabled) {
                context.read<PrayerTimesCubit>().togglePrayerNotification('maghrib', enabled);
              },
            ),
            Divider(height: 1, color: AppColors.lightGrey.withOpacity(0.3)),
            PrayerRowItem(
              prayerKey: 'isha',
              prayerName: 'العشاء',
              prayerTime: state.prayerTimes.isha,
              icon: Icons.nightlight_round,
              isCurrent: state.prayerTimes.isCurrentPrayer('isha'),
              isNext: state.prayerTimes.isNextPrayer('isha'),
              isNotificationEnabled: state.notificationSettings['isha'] ?? true,
              onNotificationToggle: (enabled) {
                context.read<PrayerTimesCubit>().togglePrayerNotification('isha', enabled);
              },
            ),
          ],
        ),
      ),
    );
  }
}
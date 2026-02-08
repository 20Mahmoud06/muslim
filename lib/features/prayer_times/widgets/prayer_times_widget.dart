import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/prayer_times_cubit.dart';
import '../cubit/prayer_times_state.dart';

class PrayerTimesWidget extends StatelessWidget {
  const PrayerTimesWidget({super.key});

  String _to12Hour(DateTime time) {
    final format = DateFormat('hh:mm', 'ar');
    final period = DateFormat('a', 'ar').format(time);
    return '${format.format(time)} $period';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit()..loadPrayerTimes(),
      child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          if (state is PrayerTimesLoading || state is PrayerTimesInitial) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          }

          if (state is PrayerTimesError || state is! PrayerTimesLoaded) {
            return const SizedBox.shrink();
          }

          final prayerTimes = state.prayerTimes;

          final List<String> prayers = [
            'العشاء',
            'المغرب',
            'العصر',
            'الظهر',
            'الشروق',
            'الفجر',
          ];

          final List<DateTime> times = [
            prayerTimes.isha,
            prayerTimes.maghrib,
            prayerTimes.asr,
            prayerTimes.dhuhr,
            prayerTimes.sunrise,
            prayerTimes.fajr,
          ];

          final List<IconData> icons = [
            Icons.nightlight_round,
            Icons.wb_twilight,
            Icons.wb_sunny,
            Icons.wb_sunny_outlined,
            Icons.brightness_5,
            Icons.wb_twilight_outlined,
          ];

          final List<String> keys = [
            'isha',
            'maghrib',
            'asr',
            'dhuhr',
            'sunrise',
            'fajr',
          ];

          String? currentPrayerKey;
          for (var key in keys) {
            if (prayerTimes.isCurrentPrayer(key)) {
              currentPrayerKey = key;
              break;
            }
          }

          String currentPrayer = '';
          if (currentPrayerKey != null) {
            final index = keys.indexOf(currentPrayerKey);
            if (index != -1) {
              currentPrayer = prayers[index];
            }
          }

          final int currentIndex = prayers.indexOf(currentPrayer);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أسماء الصلوات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: prayers.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final name = entry.value;
                      final bool isCurrent = idx == currentIndex;
                      return Expanded(
                        child: CustomText(
                          text: name,
                          textAlign: TextAlign.center,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          textColor: isCurrent
                              ? AppColors.secondaryColor
                              : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),

                  // الأيقونات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: icons.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final icon = entry.value;
                      final bool isCurrent = idx == currentIndex;
                      return Expanded(
                        child: Icon(
                          icon,
                          size: 26.sp,
                          color: isCurrent
                              ? AppColors.secondaryColor
                              : Colors.grey.shade700,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),

                  // الأوقات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: times.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final time = entry.value;
                      final bool isCurrent = idx == currentIndex;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          decoration: isCurrent
                              ? BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          )
                              : null,
                          child: CustomText(
                            text: _to12Hour(time),
                            textAlign: TextAlign.center,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            textColor:
                            isCurrent ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
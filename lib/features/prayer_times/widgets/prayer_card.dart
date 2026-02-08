import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final bool isCurrent;
  final bool isNext;
  final IconData icon;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    this.isCurrent = false,
    this.isNext = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm', 'ar');
    final periodFormat = DateFormat('a', 'ar');
    final formattedTime = timeFormat.format(prayerTime);
    final period = periodFormat.format(prayerTime);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        gradient: isCurrent
            ? LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.85),
            AppColors.secondaryColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        )
            : null,
        color: isCurrent ? null : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isNext
              ? AppColors.lightGreen.withOpacity(0.6)
              : isCurrent
              ? Colors.transparent
              : AppColors.lightGrey.withOpacity(0.2),
          width: isNext ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? AppColors.primaryColor.withOpacity(0.35)
                : isNext
                ? AppColors.lightGreen.withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: isCurrent ? 16 : isNext ? 10 : 8,
            offset: Offset(0, isCurrent ? 8 : isNext ? 5 : 3),
            spreadRadius: isCurrent ? 1 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // خلفية زخرفية خفيفة
            if (isCurrent)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.08,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/patterns/islamic_pattern.png'),
                        repeat: ImageRepeat.repeat,
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                ),
              ),

            // المحتوى الرئيسي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Row(
                children: [
                  // أيقونة الصلاة
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      gradient: isCurrent
                          ? LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.12),
                          AppColors.secondaryColor.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isCurrent
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.primaryColor.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 28.sp,
                        color: isCurrent ? Colors.white : AppColors.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // اسم الصلاة والحالة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: prayerName,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          textColor: isCurrent ? Colors.white : AppColors.primaryColor,
                        ),
                        SizedBox(height: 4.h),
                        if (isCurrent)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6.w),
                                CustomText(
                                  text: 'الصلاة الحالية',
                                  fontSize: 11.sp,
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          )
                        else if (isNext)
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                size: 14.sp,
                                color: AppColors.lightGreen,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: 'الصلاة القادمة',
                                fontSize: 12.sp,
                                textColor: AppColors.lightGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // الوقت
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isCurrent
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.primaryColor.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: formattedTime,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          textColor: isCurrent ? Colors.white : AppColors.primaryColor,
                          letterSpacing: 1.2,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: period,
                          fontSize: 11.sp,
                          textColor: isCurrent
                              ? Colors.white.withOpacity(0.85)
                              : AppColors.grey,
                          fontWeight: FontWeight.w600,
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
  }
}
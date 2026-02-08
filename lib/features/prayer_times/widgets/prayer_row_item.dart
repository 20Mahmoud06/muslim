import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class PrayerRowItem extends StatelessWidget {
  final String prayerKey;
  final String prayerName;
  final DateTime prayerTime;
  final IconData icon;
  final bool isCurrent;
  final bool isNext;
  final bool isNotificationEnabled;
  final ValueChanged<bool> onNotificationToggle;

  const PrayerRowItem({
    super.key,
    required this.prayerKey,
    required this.prayerName,
    required this.prayerTime,
    required this.icon,
    required this.isCurrent,
    required this.isNext,
    required this.isNotificationEnabled,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a', 'ar');
    final formattedTime = timeFormat.format(prayerTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: isCurrent
            ? LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.15),
            AppColors.secondaryColor.withOpacity(0.1),
          ],
        )
            : null,
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.secondaryColor.withOpacity(0.2)
                  : AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color:
              isCurrent ? AppColors.secondaryColor : AppColors.primaryColor,
            ),
          ),

          SizedBox(width: 12.w),

          // اسم الصلاة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: prayerName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textColor: isCurrent ? AppColors.primaryColor : Colors.black87,
                ),
                if (isCurrent || isNext)
                  CustomText(
                    text: isCurrent ? 'الصلاة الحالية' : 'القادمة',
                    fontSize: 11.sp,
                    textColor: isCurrent
                        ? AppColors.secondaryColor
                        : AppColors.lightGreen,
                    fontWeight: FontWeight.w600,
                  ),
              ],
            ),
          ),

          // الوقت
          CustomText(
            text: formattedTime,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            textColor: isCurrent ? AppColors.primaryColor : Colors.black87,
          ),

          SizedBox(width: 12.w),

          // زرار الإشعار
          GestureDetector(
            onTap: () => onNotificationToggle(!isNotificationEnabled),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isNotificationEnabled
                    ? AppColors.primaryColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                isNotificationEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                size: 22.sp,
                color: isNotificationEnabled ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
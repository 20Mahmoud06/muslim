import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/hijri_event_model.dart';

class UpcomingEventCard extends StatelessWidget {
  final HijriEventModel event;
  final int daysUntil;

  const UpcomingEventCard({
    super.key,
    required this.event,
    required this.daysUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: event.isImportant
              ? AppColors.primaryColor.withOpacity(0.3)
              : AppColors.lightGreen.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: event.isImportant
                ? AppColors.primaryColor.withOpacity(0.08)
                : AppColors.lightGreen.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الحدث مع العداد
          Container(
            width: 65.w,
            height: 65.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: event.isImportant
                    ? [AppColors.primaryColor, AppColors.secondaryColor]
                    : [AppColors.lightGreen, AppColors.secondaryColor.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (event.isImportant
                      ? AppColors.primaryColor
                      : AppColors.lightGreen)
                      .withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: daysUntil == 0 ? 'اليوم' : '$daysUntil',
                  fontSize: daysUntil == 0 ? 16.sp : 22.sp,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
                if (daysUntil != 0)
                  CustomText(
                    text: 'يوم',
                    fontSize: 11.sp,
                    textColor: Colors.white.withOpacity(0.9),
                  ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // معلومات الحدث
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: event.arabicTitle,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        textColor: AppColors.primaryColor,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    if (event.isImportant) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                CustomText(
                  text: event.description,
                  fontSize: 13.sp,
                  textColor: AppColors.grey,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  height: 1.4,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: event.isImportant
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : AppColors.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14.sp,
                        color: event.isImportant
                            ? AppColors.primaryColor
                            : AppColors.lightGreen,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: '${event.day} ${_getMonthName(event.month)}',
                        fontSize: 12.sp,
                        textColor: event.isImportant
                            ? AppColors.primaryColor
                            : AppColors.lightGreen,
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
    );
  }

  String _getMonthName(int month) {
    final months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الثاني',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة'
    ];
    return months[month - 1];
  }
}
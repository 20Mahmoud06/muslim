import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hijri_date/hijri_date.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class DateDisplayCard extends StatelessWidget {
  const DateDisplayCard({super.key});

  String _getHijriMonthName(int month) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijriDate = HijriDate.now();
    final gregorianFormat = DateFormat('EEEE، d MMMM yyyy', 'ar');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // التاريخ الميلادي
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: gregorianFormat.format(now),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // خط فاصل
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.lightGrey.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // التاريخ الهجري
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border_rounded,
                  color: AppColors.secondaryColor,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text:
                  '${hijriDate.hDay} ${_getHijriMonthName(hijriDate.hMonth)} ${hijriDate.hYear} هـ',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
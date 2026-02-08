import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hijri_date/hijri_date.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class LocationHeader extends StatelessWidget {
  final String cityName;
  final VoidCallback onLocationTap;

  const LocationHeader({
    super.key,
    required this.cityName,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijriDate = HijriDate.now();
    final gregorianFormat = DateFormat('EEEE، d MMMM yyyy', 'ar');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.secondaryColor.withOpacity(0.85),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // الموقع
          GestureDetector(
            onTap: onLocationTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: cityName,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 18.h),

          // التواريخ
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // التاريخ الميلادي
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white.withOpacity(0.9),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: gregorianFormat.format(now),
                      fontSize: 14.sp,
                      textColor: Colors.white,
                      fontWeight: FontWeight.w600,
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
                        Colors.white.withOpacity(0.3),
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
                      color: Colors.white.withOpacity(0.9),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: '${hijriDate.hDay} ${_getHijriMonthName(hijriDate.hMonth)} ${hijriDate.hYear} هـ',
                      fontSize: 14.sp,
                      textColor: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/core/routes/route_names.dart';
import 'custom_icon_button.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          // Shadow من الأعلى (محسّن)
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15.r,
            offset: Offset(0, -4.h),
            spreadRadius: 1.r,
          ),
          // Shadow من الأسفل
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 9.h),
          ),
          // Shadow إضافي لعمق أكبر
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.r,
            offset: Offset(0, 5.h),
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        children: [
          // First row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/quran.png',
                    iconName: 'المصحف',
                    width: 60.w,
                    onTap: () => Get.toNamed(RouteNames.quran),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/tasbih.png',
                    iconName: 'السبحة',
                    width: 55.w,
                    height: 11.h,
                    onTap: () => Get.toNamed(RouteNames.tasbih),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/duaa.png',
                    iconName: 'أذكار',
                    width: 52.w,
                    height: 15.h,
                    onTap: () => Get.toNamed(RouteNames.azkar),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/kaaba-qiblah.png',
                    iconName: 'القبلة',
                    width: 60.w,
                    onTap: () => Get.toNamed(RouteNames.qiblah),
                  ),
                ),
              ],
            ),
          ),

          // Second row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/allah-names.png',
                    iconName: 'أسماء الله الحسني',
                    width: 60.w,
                    onTap: () => Get.toNamed(RouteNames.allahNames),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/mosque-salaah-time.png',
                    iconName: 'أوقات الصلاة',
                    width: 60.w,
                    height: 12.h,
                    onTap: () => Get.toNamed(RouteNames.prayerTimesDetail),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/islam.png',
                    iconName: 'الحديث الشريف',
                    width: 55.w,
                    onTap: () => Get.toNamed(RouteNames.hadith),
                  ),
                ),
                Expanded(
                  child: CustomIconButton(
                    image: 'assets/icons/calendar.png',
                    iconName: 'التقويم الهجري',
                    width: 50.w,
                    height: 9.h,
                    onTap: () => Get.toNamed(RouteNames.hijriCalendar),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri_date/hijri.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class HijriMonthHeader extends StatelessWidget {
  final HijriDate currentDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onTodayTap;

  const HijriMonthHeader({
    super.key,
    required this.currentDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // الصف الأول: التنقل بين الأشهر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الشهر التالي
              _buildNavigationButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: onNextMonth,
              ),
              // الشهر والسنة
              Expanded(
                child: Column(
                  children: [
                    CustomText(
                      text: currentDate.getLongMonthName(),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.primaryColor,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: '${currentDate.hYear} هـ',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
              // زر الشهر السابق
              _buildNavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: onPreviousMonth,
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // زر اليوم
          GestureDetector(
            onTap: onTodayTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.lightGreen.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.today_rounded,
                    color: AppColors.primaryColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'اليوم',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    textColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.lightGreen.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 18.sp,
        ),
      ),
    );
  }
}
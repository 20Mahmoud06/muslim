import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class BuildLoading extends StatelessWidget {
  const BuildLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.background,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'جاري تحديد موقعك...',
              fontSize: 16.sp,
              textColor: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'الرجاء الانتظار',
              fontSize: 13.sp,
              textColor: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

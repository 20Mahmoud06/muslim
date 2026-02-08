import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class BuildError extends StatelessWidget {
  const BuildError({super.key, required this.title, required this.message, required this.buttonText, required this.onPressed});

  final String title,message,buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
                color: Colors.red.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: 60.sp,
                color: Colors.red.shade400,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: title,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: message,
                fontSize: 14.sp,
                textColor: Colors.white,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                shadowColor: AppColors.primaryColor.withOpacity(0.3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: buttonText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16.sp,
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

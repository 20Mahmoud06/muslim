import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class ErrorStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80.sp, color: AppColors.grey),
            SizedBox(height: 20.h),
            CustomText(
              text: 'لم نتمكن من تحديد موقعك',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomText(
              text:
              'يرجى التأكد من تفعيل خدمات الموقع والسماح للتطبيق بالوصول إليها',
              fontSize: 14.sp,
              textColor: AppColors.grey,
              textAlign: TextAlign.center,
              height: 1.5,
            ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: Icon(Icons.refresh, color: Colors.white, size: 20.sp),
              label: CustomText(
                text: 'إعادة المحاولة',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
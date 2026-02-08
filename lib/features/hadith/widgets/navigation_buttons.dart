import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class NavigationButtons extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const NavigationButtons({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر السابق
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onPrevious,
              style: ElevatedButton.styleFrom(
                backgroundColor: onPrevious != null
                    ? AppColors.primaryColor
                    : AppColors.lightGrey,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
              label: CustomText(
                text: 'السابق',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // العداد
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CustomText(
              text: '${currentIndex + 1} / $totalCount',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
          ),

          SizedBox(width: 12.w),

          // زر التالي
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: onNext != null
                    ? AppColors.primaryColor
                    : AppColors.lightGrey,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              icon: CustomText(
                text: 'التالي',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
              label: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
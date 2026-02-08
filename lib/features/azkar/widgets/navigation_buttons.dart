import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class NavigationButtons extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final List<Color> gradient;

  const NavigationButtons({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: canGoPrevious ? AppColors.lightGrey : AppColors.veryLightGrey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: canGoPrevious ? onPrevious : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16.sp,
                          color: canGoPrevious ? AppColors.primaryColor : AppColors.grey,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: 'السابق',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          textColor: canGoPrevious ? AppColors.primaryColor : AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Next Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: canGoNext
                    ? LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: canGoNext ? null : AppColors.veryLightGrey,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: canGoNext
                    ? [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: canGoNext ? onNext : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'التالي',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          textColor: canGoNext ? Colors.white : AppColors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: canGoNext ? Colors.white : AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
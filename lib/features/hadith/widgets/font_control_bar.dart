import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class FontControlBar extends StatelessWidget {
  final double fontSize;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const FontControlBar({
    super.key,
    required this.fontSize,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'حجم الخط',
            fontSize: 13.sp,
            textColor: AppColors.grey,
          ),
          SizedBox(width: 16.w),
          // زر تصغير
          IconButton(
            onPressed: onDecrease,
            icon: Icon(
              Icons.remove_circle_outline,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          // عرض الحجم
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CustomText(
              text: '${fontSize.toInt()}',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
          ),
          // زر تكبير
          IconButton(
            onPressed: onIncrease,
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
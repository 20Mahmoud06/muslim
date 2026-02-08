import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class PageIndicatorDot extends StatelessWidget {
  final bool isActive;

  const PageIndicatorDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 8.h,
        width: isActive ? 28.w : 8.w,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.image,
    required this.iconName,
    this.width,
    this.height,
    this.imageHeight,
    this.onTap,
  });

  final String image;
  final String iconName;
  final double? width;
  final double? imageHeight;
  final double? height;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: width ?? 50.w,
            height: imageHeight ?? width ?? 50.w,
            color: AppColors.primaryColor,
            fit: BoxFit.contain,
          ),
          SizedBox(height: height ?? 8.h),
          CustomText(
            text: iconName,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            textColor: AppColors.primaryColor,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
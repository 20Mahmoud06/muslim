import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomOnboarding extends StatelessWidget {
  final Widget? imageWidget;
  final double? topPadding;
  final double? bottomPadding;
  final String title;
  final String description;
  final String buttonText;
  final Future<void> Function()? onButtonPressed;
  final bool showNextButton;
  final double? imageHeight;
  final double? titleTopPadding;
  final double? descriptionTopPadding;
  final double? buttonTopPadding;

  const CustomOnboarding({
    super.key,
    this.imageWidget,
    this.topPadding,
    this.bottomPadding,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.showNextButton = true,
    this.imageHeight,
    this.titleTopPadding,
    this.descriptionTopPadding,
    this.buttonTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          if (topPadding != null) SizedBox(height: topPadding!.h),

          if (imageWidget != null) ...[
            SizedBox(
              height: imageHeight?.h,
              child: imageWidget,
            ),
          ],

          SizedBox(height: (titleTopPadding ?? 20).h),

          CustomText(
            text: title,
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            textColor: AppColors.primaryColor,
          ),

          SizedBox(height: (descriptionTopPadding ?? 16).h),

          CustomText(
            text: description,
            fontSize: 16.sp,
            textColor: AppColors.grey,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: (buttonTopPadding ?? 48).h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: CustomText(
                text: buttonText,
                textColor: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (bottomPadding != null) SizedBox(height: bottomPadding!.h),
          if (!showNextButton) SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
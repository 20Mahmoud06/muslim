import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class BuildDirectionInfo extends StatelessWidget {
  final QiblahDirection qiblahDirection;
  final bool isAligned;

  const BuildDirectionInfo({
    super.key,
    required this.qiblahDirection,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    final angle = qiblahDirection.qiblah.round();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAligned
              ? [
            AppColors.lightGreen.withOpacity(0.2),
            AppColors.primaryColor.withOpacity(0.2),
          ]
              : [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isAligned
              ? AppColors.lightGreen.withOpacity(0.4)
              : AppColors.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAligned)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.lightGreen,
                  size: 24.sp,
                ),
              if (isAligned) SizedBox(width: 8.w),
              Flexible(
                child: CustomText(
                  text: isAligned
                      ? 'أنت متجه نحو القبلة ✨'
                      : 'اتجاه القبلة من °$angle شمالاً',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textColor: isAligned
                      ? AppColors.lightGreen
                      : AppColors.primaryColor,
                ),
              ),
            ],
          ),
          if (!isAligned) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: 'حرك جهازك للاتجاه الصحيح',
                fontSize: 12.sp,
                textColor: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
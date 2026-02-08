import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/hadith_model.dart';

class HadithContentWidget extends StatelessWidget {
  final HadithModel hadith;
  final String hadithName;
  final double fontSize;

  const HadithContentWidget({
    super.key,
    required this.hadith,
    required this.hadithName,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // رقم الحديث
          Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CustomText(
                text: '${hadith.idInBook}',
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // اسم الحديث
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.secondaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.label_important_rounded,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: CustomText(
                    text: hadithName,
                    fontSize: 16.sp,
                    textColor: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // نص الحديث العربي
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomText(
              text: hadith.arabic,
              fontSize: fontSize.sp,
              textColor: AppColors.primaryColor,
              height: 2.2,
              textAlign: TextAlign.justify,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 20.h),

          // المصدر
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.lightGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified,
                  color: AppColors.lightGreen,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'المصدر',
                        fontSize: 12.sp,
                        textColor: AppColors.grey,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: hadith.source,
                        fontSize: 14.sp,
                        textColor: AppColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: 'صحيح',
                    fontSize: 12.sp,
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
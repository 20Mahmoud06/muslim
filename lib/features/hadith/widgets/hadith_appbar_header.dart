import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/custom_text.dart';

class HadithAppBarHeader extends StatelessWidget {
  const HadithAppBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.book_rounded,
            size: 44.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 18.sp,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: 'للإمام يحيى بن شرف النووي',
                fontSize: 14.sp,
                textColor: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
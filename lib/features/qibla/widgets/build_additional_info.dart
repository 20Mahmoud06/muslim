import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class BuildAdditionalInfo extends StatelessWidget {
  final QiblahDirection qiblahDirection;

  const BuildAdditionalInfo({
    super.key,
    required this.qiblahDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(
            label: 'اتجاه البوصلة',
            value: '${qiblahDirection.direction.round()}°',
            icon: Icons.explore_rounded,
          ),
          Container(
            width: 1,
            height: 40.h,
            color: AppColors.grey.withOpacity(0.2),
          ),
          _InfoItem(
            label: 'اتجاه القبلة',
            value: '${qiblahDirection.qiblah.round()}°',
            icon: Icons.mosque_rounded,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 24.sp,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: value,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryColor,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          fontSize: 12.sp,
          textColor: AppColors.grey,
        ),
      ],
    );
  }
}
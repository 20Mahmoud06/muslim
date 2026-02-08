import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class PrayerDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsTap;

  const PrayerDetailAppBar({
    super.key,
    required this.onSettingsTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: CustomText(
        text: 'مواقيت الصلاة',
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        textColor: Colors.white,
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          onPressed: onSettingsTap,
          tooltip: 'إعدادات الإشعارات',
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class XiaomiPermissionDialog extends StatelessWidget {
  const XiaomiPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 48.sp,
                color: Colors.orange,
              ),
            ),

            SizedBox(height: 16.h),

            // العنوان
            CustomText(
              text: 'تنبيه مهم لمستخدمي Xiaomi/Redmi',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // الوصف
            CustomText(
              text:
              'لضمان عمل إشعارات الصلاة بشكل صحيح، يُرجى تفعيل الأذونات التالية:',
              fontSize: 14.sp,
              textColor: Colors.black87,
              textAlign: TextAlign.center,
              height: 1.5,
            ),

            SizedBox(height: 20.h),

            // القائمة
            _buildPermissionItem(
              icon: Icons.power_settings_new,
              title: 'التشغيل التلقائي',
              description: 'الإعدادات > التطبيقات > مسلم > التشغيل التلقائي',
            ),

            SizedBox(height: 12.h),

            _buildPermissionItem(
              icon: Icons.play_arrow,
              title: 'التشغيل في الخلفية',
              description: 'الإعدادات > التطبيقات > مسلم > التشغيل في الخلفية',
            ),

            SizedBox(height: 12.h),

            _buildPermissionItem(
              icon: Icons.battery_charging_full,
              title: 'بدون قيود في البطارية',
              description: 'الإعدادات > التطبيقات > مسلم > توفير البطارية > بدون قيود',
            ),

            SizedBox(height: 20.h),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(
                      text: 'تم',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryColor,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: description,
                  fontSize: 12.sp,
                  textColor: Colors.black54,
                  height: 1.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
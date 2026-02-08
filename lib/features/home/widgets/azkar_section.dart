import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../../../shared/custom_text.dart';
import '../../azkar/models/azkar_model.dart';
import '../../azkar/services/daily_azkar_service.dart';

class AzkarSection extends StatefulWidget {
  const AzkarSection({super.key});

  @override
  State<AzkarSection> createState() => _AzkarSectionState();
}

class _AzkarSectionState extends State<AzkarSection> {
  Zikr? _dailyZikr;
  bool _isLoading = true;
  String _categoryTitle = 'ذكر اليوم';

  @override
  void initState() {
    super.initState();
    _loadDailyZikr();
  }

  Future<void> _loadDailyZikr() async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final hour = now.hour;

    // تحديد العنوان حسب الوقت
    if (hour >= 5 && hour < 12) {
      _categoryTitle = 'أذكار الصباح';
    } else if (hour >= 15 && hour < 18) {
      _categoryTitle = 'أذكار المساء';
    } else {
      _categoryTitle = 'ذكر اليوم';
    }

    final zikr = await DailyAzkarService.loadDailyZikr();
    setState(() {
      _dailyZikr = zikr;
      _isLoading = false;
    });
  }

  void _copyZikr() {
    if (_dailyZikr == null) return;

    Clipboard.setData(ClipboardData(text: _dailyZikr!.text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            const Text('تم نسخ الذكر'),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 9.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icon
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/duaa.png',
                  width: 40.w,
                  height: 40.h,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: _categoryTitle,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
          Container(
            height: 0.5.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
          SizedBox(height: 15.h),
          // Zikr content or loading
          _isLoading
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          )
              : _dailyZikr == null
              ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
            child: CustomText(
              text: 'لم يتم العثور على ذكر',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.secondaryColor.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              text: _dailyZikr!.text,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.secondaryColor,
              textAlign: TextAlign.right,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              height: 1.5,
            ),
          ),

          SizedBox(height: 20.h),

          // Bottom buttons row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "المزيد" button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(RouteNames.azkar),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      foregroundColor: AppColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: CustomText(
                      text: 'المزيد',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // "نسخ" button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _dailyZikr != null ? _copyZikr : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.5),
                    ),
                    child: CustomText(
                      text: 'نسخ',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
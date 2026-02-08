import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../../../shared/custom_text.dart';
import '../../hadith/model/hadith_model.dart';
import '../../hadith/data/hadith_names.dart';
import '../../hadith/services/daily_hadith_service.dart';

class DailyHadithSection extends StatefulWidget {
  const DailyHadithSection({super.key});

  @override
  State<DailyHadithSection> createState() => _DailyHadithSectionState();
}

class _DailyHadithSectionState extends State<DailyHadithSection> {
  HadithModel? _dailyHadith;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyHadith();
  }

  Future<void> _loadDailyHadith() async {
    setState(() => _isLoading = true);
    final hadith = await DailyHadithService.loadDailyHadith();
    setState(() {
      _dailyHadith = hadith;
      _isLoading = false;
    });
  }

  String _getHadithName() {
    if (_dailyHadith == null) return 'حديث اليوم';
    final index = _dailyHadith!.idInBook - 1;
    return index >= 0 && index < HadithNames.names.length
        ? HadithNames.names[index]
        : 'الحديث ${_dailyHadith!.numberInArabic}';
  }

  void _copyHadith() {
    if (_dailyHadith == null) return;

    final text = '''
الحديث ${_dailyHadith!.numberInArabic}
${_getHadithName()}

${_dailyHadith!.arabic}

من كتاب الأربعين النووية للإمام النووي رحمه الله
    ''';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            const Text('تم نسخ الحديث'),
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 7.h),
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
                Padding(
                  padding: EdgeInsets.only(top: 3.0.h),
                  child: Icon(
                    Icons.nightlight_outlined,
                    color: AppColors.primaryColor,
                    size: 30.w,
                  ),
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: 'حديث اليوم',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
          Container(
            height: 1.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: AppColors.primaryColor.withOpacity(0.1),
          ),

          // Hadith content or loading
          _isLoading
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          )
              : _dailyHadith == null
              ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
            child: CustomText(
              text: 'لم يتم العثور على حديث',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              textColor: AppColors.secondaryColor.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الحديث
                CustomText(
                  text: _getHadithName(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryColor,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 8.h),
                // نص الحديث
                CustomText(
                  text: _dailyHadith!.arabic,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.secondaryColor,
                  textAlign: TextAlign.right,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  height: 1.4,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Bottom buttons row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "المزيد" button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(RouteNames.hadith),
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
                    onPressed: _dailyHadith != null ? _copyHadith : null,
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
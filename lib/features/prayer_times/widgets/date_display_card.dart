import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../../hijri_calendar/model/hijri_date_result.dart';
import '../../hijri_calendar/services/hijri_date_service.dart';

class DateDisplayCard extends StatefulWidget {
  const DateDisplayCard({super.key});

  @override
  State<DateDisplayCard> createState() => _DateDisplayCardState();
}

class _DateDisplayCardState extends State<DateDisplayCard> {
  HijriDateResult? _hijriDate;

  @override
  void initState() {
    super.initState();
    HijriDateService.adjustmentNotifier.addListener(_onAdjustmentChanged);
    // ✅ نحمل بعد أول frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHijriDate());
  }

  @override
  void dispose() {
    HijriDateService.adjustmentNotifier.removeListener(_onAdjustmentChanged);
    super.dispose();
  }

  void _onAdjustmentChanged() => _loadHijriDate();

  Future<void> _loadHijriDate() async {
    final date = await HijriDateService.getCurrentHijriDate();
    if (mounted) setState(() => _hijriDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final gregorianFormat = DateFormat('EEEE، d MMMM yyyy', 'ar');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05),
                blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today,
                    color: AppColors.primaryColor, size: 18.sp),
                SizedBox(width: 8.w),
                CustomText(
                  text: gregorianFormat.format(now),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  AppColors.lightGrey.withOpacity(0.5),
                  Colors.transparent,
                ]),
              ),
            ),
            SizedBox(height: 10.h),
            _hijriDate != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border_rounded,
                    color: AppColors.secondaryColor, size: 18.sp),
                SizedBox(width: 8.w),
                CustomText(
                  text:
                  '${_hijriDate!.hDay} ${HijriDateService.getArabicMonthName(_hijriDate!.hMonth)} ${_hijriDate!.hYear} هـ',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.secondaryColor,
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryColor),
                  ),
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'جاري التحميل...',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/hijri_calendar_cubit.dart';

class HijriAdjustmentDialog extends StatelessWidget {
  const HijriAdjustmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HijriCalendarCubit>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomText(
                    text: 'تعديل عدد أيام الشهر',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    textColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // الشرح
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomText(
                          text: 'في حالة رؤية أو عدم رؤية الهلال',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text:
                    '• إذا تمت رؤية الهلال: اجعل الشهر 30 يوم\n• إذا لم يُرَ الهلال: اجعل الشهر 29 يوم',
                    fontSize: 12.sp,
                    textColor: AppColors.grey,
                    textAlign: TextAlign.right,
                    height: 1.6,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // معلومات الشهر الحالي
            BlocBuilder<HijriCalendarCubit, HijriCalendarState>(
              builder: (context, state) {
                if (state is HijriCalendarLoaded) {
                  final originalDays = cubit.currentDate.getDaysInMonth(
                    cubit.currentDate.hYear,
                    cubit.currentDate.hMonth,
                  );
                  final currentDays = cubit.currentMonthLength;
                  final monthName = cubit.currentDate.getLongMonthName();

                  return Column(
                    children: [
                      // عرض الشهر الحالي
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor.withOpacity(0.1),
                              AppColors.lightGreen.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomText(
                              text: monthName,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: AppColors.primaryColor,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    CustomText(
                                      text: 'العدد الحالي',
                                      fontSize: 11.sp,
                                      textColor: AppColors.grey,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: '$currentDays يوم',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      textColor: currentDays != originalDays
                                          ? AppColors.secondaryColor
                                          : AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                                if (currentDays != originalDays) ...[
                                  SizedBox(width: 20.w),
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    color: AppColors.grey,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    children: [
                                      CustomText(
                                        text: 'الأصلي',
                                        fontSize: 11.sp,
                                        textColor: AppColors.grey,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: '$originalDays يوم',
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        textColor: AppColors.grey.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // أزرار التعديل
                      Row(
                        children: [
                          // زر 30 يوم
                          Expanded(
                            child: _buildDayButton(
                              days: 30,
                              label: '30 يوم',
                              subtitle: 'رؤية الهلال',
                              icon: Icons.visibility_rounded,
                              isActive: currentDays == 30,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.secondaryColor,
                                ],
                              ),
                              onTap: () async {
                                await cubit.extendCurrentMonth();
                              },
                            ),
                          ),

                          SizedBox(width: 12.w),

                          // زر 29 يوم
                          Expanded(
                            child: _buildDayButton(
                              days: 29,
                              label: '29 يوم',
                              subtitle: 'عدم الرؤية',
                              icon: Icons.visibility_off_rounded,
                              isActive: currentDays == 29,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.lightGreen,
                                  AppColors.secondaryColor.withOpacity(0.8),
                                ],
                              ),
                              onTap: () async {
                                await cubit.shortenCurrentMonth();
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // زر إعادة تعيين الشهر الحالي
                      if (cubit.hasCurrentMonthAdjustment)
                        _buildResetButton(
                          label: 'إعادة تعيين هذا الشهر',
                          onTap: () async {
                            await cubit.resetCurrentMonth();
                          },
                        ),

                      // زر إعادة تعيين جميع التعديلات
                      if (state.monthAdjustments.isNotEmpty &&
                          state.monthAdjustments.length > 1)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: _buildResetButton(
                            label:
                            'إعادة تعيين جميع التعديلات (${state.monthAdjustments.length} شهر)',
                            onTap: () async {
                              await cubit.resetAllAdjustments();
                            },
                            isWarning: true,
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            SizedBox(height: 20.h),

            // زر الإغلاق
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: CustomText(
                  text: 'إغلاق',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton({
    required int days,
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          gradient: isActive ? gradient : null,
          color: isActive ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : AppColors.primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.primaryColor,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: label,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              textColor: isActive ? Colors.white : AppColors.primaryColor,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: subtitle,
              fontSize: 11.sp,
              textColor: isActive
                  ? Colors.white.withOpacity(0.9)
                  : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton({
    required String label,
    required VoidCallback onTap,
    bool isWarning = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isWarning ? Colors.red.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isWarning ? Colors.red.shade300 : Colors.orange.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh_rounded,
              color: isWarning ? Colors.red.shade700 : Colors.orange.shade700,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: label,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              textColor:
              isWarning ? Colors.red.shade700 : Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
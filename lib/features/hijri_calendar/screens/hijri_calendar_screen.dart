import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/hijri_calendar_cubit.dart';
import '../widgets/calendar_day_cell.dart';
import '../widgets/hijri_month_header.dart';
import '../widgets/hijri_offset_dialog.dart';
import '../widgets/upcoming_event_card.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HijriCalendarCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
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
            text: 'التقويم الهجري',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            textColor: Colors.white,
          ),
          actions: [
            BlocBuilder<HijriCalendarCubit, HijriCalendarState>(
              builder: (context, state) {
                return IconButton(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      if (state is HijriCalendarLoaded &&
                          state.monthAdjustments.isNotEmpty)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: CustomText(
                              text: '${state.monthAdjustments.length}',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<HijriCalendarCubit>(),
                        child: const HijriAdjustmentDialog(),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<HijriCalendarCubit, HijriCalendarState>(
          builder: (context, state) {
            if (state is HijriCalendarLoaded) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (context.read<HijriCalendarCubit>().hasCurrentMonthAdjustment)
                        Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.blue.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: Colors.blue.shade700,
                                size: 22.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'الشهر معدّل',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.blue.shade900,
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: _getAdjustmentMessage(context),
                                      fontSize: 12.sp,
                                      textColor: Colors.blue.shade700,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      HijriMonthHeader(
                        currentDate: state.currentDate,
                        onPreviousMonth: () =>
                            context.read<HijriCalendarCubit>().changeMonth(-1),
                        onNextMonth: () =>
                            context.read<HijriCalendarCubit>().changeMonth(1),
                        onTodayTap: () =>
                            context.read<HijriCalendarCubit>().goToToday(),
                      ),
                      SizedBox(height: 20.h),
                      _buildWeekDaysHeader(),
                      SizedBox(height: 12.h),
                      _buildCalendarGrid(context, state),
                      SizedBox(height: 24.h),
                      if (state.upcomingEvents.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.lightGreen,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            CustomText(
                              text: 'المناسبات القادمة',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              textColor: AppColors.primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: CustomText(
                                text: '${state.upcomingEvents.length}',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // ⭐ تحديث: استخدام الدالة الجديدة لحساب الأيام
                        ...state.upcomingEvents.map((event) {
                          final cubit = context.read<HijriCalendarCubit>();
                          final daysUntil = cubit.getDaysUntilEvent(event);

                          return UpcomingEventCard(
                            event: event,
                            daysUntil: daysUntil,
                          );
                        }),
                      ],
                      Container(
                        margin: EdgeInsets.only(top: 16.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomText(
                                text:
                                'الأيام المميزة بدائرة ملونة تحتوي على أحداث إسلامية مهمة',
                                fontSize: 13.sp,
                                textColor: AppColors.grey,
                                textAlign: TextAlign.right,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  String _getAdjustmentMessage(BuildContext context) {
    final cubit = context.read<HijriCalendarCubit>();
    final originalDays = cubit.currentDate.getDaysInMonth(
      cubit.currentDate.hYear,
      cubit.currentDate.hMonth,
    );
    final adjustedDays = cubit.currentMonthLength;
    return 'الشهر معدّل إلى $adjustedDays يوم (بدلاً من $originalDays)';
  }

  Widget _buildWeekDaysHeader() {
    final weekDays = [
      'السبت',
      'الجمعة',
      'الخميس',
      'الأربعاء',
      'الثلاثاء',
      'الإثنين',
      'الأحد'
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.08),
            AppColors.lightGreen.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: weekDays.reversed.map((day) {
          return Expanded(
            child: CustomText(
              text: day,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              textColor: AppColors.primaryColor,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, HijriCalendarLoaded state) {
    final cubit = context.read<HijriCalendarCubit>();
    final daysInMonth = cubit.getAdjustedMonthLength(
      state.currentDate.hYear,
      state.currentDate.hMonth,
    );

    // ⭐ حساب يوم الأسبوع الصحيح مع مراعاة التعديلات
    final firstWeekday = cubit.getAdjustedFirstWeekday(
      state.currentDate.hYear,
      state.currentDate.hMonth,
    );

    List<Widget> dayWidgets = [];
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final isToday = cubit.isToday(
        day,
        state.currentDate.hMonth,
        state.currentDate.hYear,
      );
      final isSelected = state.selectedDate != null &&
          state.selectedDate!.hDay == day &&
          state.selectedDate!.hMonth == state.currentDate.hMonth;
      final hasEvent = cubit.hasEventOnDay(day);
      final isImportant = cubit.isImportantDay(day);

      dayWidgets.add(
        CalendarDayCell(
          day: day,
          isToday: isToday,
          isSelected: isSelected,
          hasEvent: hasEvent,
          isImportantEvent: isImportant,
          isCurrentMonth: true,
          onTap: () => cubit.selectDate(day),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: dayWidgets,
    );
  }
}
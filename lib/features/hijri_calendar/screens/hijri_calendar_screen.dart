import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri_date/hijri.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/hijri_calendar_cubit.dart';
import '../widgets/calendar_day_cell.dart';
import '../widgets/hijri_month_header.dart';
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
                      // رأس الشهر
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

                      // أيام الأسبوع
                      _buildWeekDaysHeader(),

                      SizedBox(height: 12.h),

                      // التقويم
                      _buildCalendarGrid(context, state),

                      SizedBox(height: 24.h),

                      // الأحداث القادمة
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
                        ...state.upcomingEvents.map((event) {
                          final now = HijriDate.now();
                          final daysUntil = event.daysUntil(
                            now.hDay,
                            now.hMonth,
                            now.lengthOfMonth,
                          );
                          return UpcomingEventCard(
                            event: event,
                            daysUntil: daysUntil,
                          );
                        }),
                      ],

                      // ملاحظة عن الأحداث
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

  Widget _buildWeekDaysHeader() {
    final weekDays = ['السبت','الجمعة','الخميس','الأربعاء','الثلاثاء','الإثنين','الأحد'];
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
    final daysInMonth = state.currentDate.lengthOfMonth;
    final firstDayOfMonth = HijriDate.fromHijri(
      state.currentDate.hYear,
      state.currentDate.hMonth,
      1,
    );

    final gregorianFirst = firstDayOfMonth.hijriToGregorian(
      firstDayOfMonth.hYear,
      firstDayOfMonth.hMonth,
      firstDayOfMonth.hDay,
    );
    final firstWeekday = gregorianFirst.weekday == 7 ? 0 : gregorianFirst.weekday;

    final today = HijriDate.now();
    final isCurrentMonth = state.currentDate.hMonth == today.hMonth &&
        state.currentDate.hYear == today.hYear;

    List<Widget> dayWidgets = [];

    // إضافة خلايا فارغة قبل أول يوم
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // إضافة أيام الشهر
    for (int day = 1; day <= daysInMonth; day++) {
      final isToday = isCurrentMonth && day == today.hDay;
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
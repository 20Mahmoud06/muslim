import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasEvent;
  final bool isImportantEvent;
  final bool isCurrentMonth;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasEvent,
    required this.isImportantEvent,
    required this.isCurrentMonth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: Container(
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(14.r),
          border: _getBorder(),
          boxShadow: _getBoxShadow(),
        ),
        child: Stack(
          children: [
            // رقم اليوم
            Center(
              child: CustomText(
                text: '$day',
                fontSize: 15.sp,
                fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w600,
                textColor: _getTextColor(),
              ),
            ),
            // مؤشر الحدث
            if (hasEvent && isCurrentMonth)
              Positioned(
                bottom: 3.h,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    width: isImportantEvent ? 8.w : 6.w,
                    height: isImportantEvent ? 8.w : 6.w,
                    decoration: BoxDecoration(
                      gradient: isImportantEvent
                          ? LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                      )
                          : null,
                      color: isImportantEvent ? null : AppColors.lightGreen,
                      shape: BoxShape.circle,
                      boxShadow: isImportantEvent
                          ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isCurrentMonth) {
      return Colors.transparent;
    }
    if (isSelected) {
      return AppColors.primaryColor;
    }
    if (isToday) {
      return AppColors.lightGreen.withOpacity(0.15);
    }
    if (hasEvent) {
      return Colors.white;
    }
    return Colors.grey.shade50;
  }

  Border? _getBorder() {
    if (!isCurrentMonth) return null;

    if (isToday && !isSelected) {
      return Border.all(
        color: AppColors.primaryColor,
        width: 2,
      );
    }
    if (hasEvent && !isSelected && !isToday) {
      return Border.all(
        color: isImportantEvent
            ? AppColors.primaryColor.withOpacity(0.3)
            : AppColors.lightGreen.withOpacity(0.3),
        width: 1.5,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (!isCurrentMonth) return null;

    if (isSelected) {
      return [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ];
    }
    if (isImportantEvent && !isSelected) {
      return [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.1),
          blurRadius: 6,
          spreadRadius: 0.5,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }

  Color _getTextColor() {
    if (!isCurrentMonth) {
      return AppColors.lightGrey;
    }
    if (isSelected) {
      return Colors.white;
    }
    if (isToday) {
      return AppColors.primaryColor;
    }
    if (hasEvent) {
      return AppColors.primaryColor;
    }
    return AppColors.grey;
  }
}
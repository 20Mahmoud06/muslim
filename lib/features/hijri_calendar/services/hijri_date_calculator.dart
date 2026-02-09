import 'package:hijri_date/hijri.dart';

/// خدمة متخصصة في حساب التواريخ الهجرية مع دعم التعديلات على الأشهر
class HijriDateCalculator {
  final Map<String, int> monthAdjustments;

  HijriDateCalculator(this.monthAdjustments);

  /// الحصول على عدد أيام الشهر بعد التعديل
  int getAdjustedMonthLength(int year, int month) {
    String monthKey = '$year-$month';

    if (monthAdjustments.containsKey(monthKey)) {
      return monthAdjustments[monthKey]!;
    }

    // إذا لم يكن هناك تعديل، نرجع القيمة الأصلية
    final tempDate = HijriDate.now();
    return tempDate.getDaysInMonth(year, month);
  }

  /// حساب عدد الأيام الكلية بين تاريخين (مع التعديلات)
  int calculateTotalDaysBetween({
    required int fromYear,
    required int fromMonth,
    required int fromDay,
    required int toYear,
    required int toMonth,
    required int toDay,
  }) {
    // لو نفس الشهر والسنة
    if (fromYear == toYear && fromMonth == toMonth) {
      return toDay - fromDay;
    }

    int totalDays = 0;

    // الأيام المتبقية في الشهر الحالي
    int currentMonthDays = getAdjustedMonthLength(fromYear, fromMonth);
    totalDays += (currentMonthDays - fromDay);

    // حساب الشهور الكاملة بينهم
    int currentYear = fromYear;
    int currentMonth = fromMonth + 1;

    while (currentYear < toYear || (currentYear == toYear && currentMonth < toMonth)) {
      totalDays += getAdjustedMonthLength(currentYear, currentMonth);

      currentMonth++;
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    // إضافة أيام الشهر الأخير
    totalDays += toDay;

    return totalDays;
  }

  /// حساب يوم الأسبوع الصحيح لأول يوم في الشهر (مع التعديلات)
  int getAdjustedFirstWeekday(int year, int month) {
    // نبدأ من يوم معروف (أول محرم من السنة)
    final firstDayOfYear = HijriDate.fromHijri(year, 1, 1);
    final gregorianFirst = firstDayOfYear.hijriToGregorian(
      firstDayOfYear.hYear,
      firstDayOfYear.hMonth,
      firstDayOfYear.hDay,
    );

    // يوم الأسبوع لأول محرم (0 = أحد، 1 = إثنين، ..., 6 = سبت)
    int weekday = gregorianFirst.weekday == 7 ? 0 : gregorianFirst.weekday;

    // نحسب عدد الأيام من أول محرم لأول الشهر المطلوب (مع التعديلات)
    int totalDays = 0;

    for (int m = 1; m < month; m++) {
      totalDays += getAdjustedMonthLength(year, m);
    }

    // نحسب يوم الأسبوع الجديد
    weekday = (weekday + totalDays) % 7;

    return weekday;
  }

  /// حساب عدد الأيام حتى حدث معين (مع التعديلات)
  int calculateDaysUntilEvent({
    required int eventDay,
    required int eventMonth,
    required int currentYear,
    required int currentMonth,
    required int currentDay,
  }) {
    int eventYear = currentYear;

    // لو الحدث في شهر قبل الشهر الحالي، يبقى السنة الجاية
    if (eventMonth < currentMonth) {
      eventYear++;
    } else if (eventMonth == currentMonth && eventDay < currentDay) {
      // لو نفس الشهر بس اليوم فات
      eventYear++;
    }

    return calculateTotalDaysBetween(
      fromYear: currentYear,
      fromMonth: currentMonth,
      fromDay: currentDay,
      toYear: eventYear,
      toMonth: eventMonth,
      toDay: eventDay,
    );
  }
}
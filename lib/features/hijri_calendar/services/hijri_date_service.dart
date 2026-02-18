import 'package:flutter/material.dart';
import 'package:hijri_date/hijri.dart';
import '../model/hijri_date_result.dart';
import '../utils/hijri_offset_prefs.dart';

class HijriDateService {
  static Map<String, int>? _cachedAdjustments;
  static DateTime? _lastCacheUpdate;
  static bool _defaultsApplied = false;

  static final ValueNotifier<int> adjustmentNotifier = ValueNotifier(0);

  static Future<HijriDateResult> getCurrentHijriDate() async {
    // لو الـ cache فاضي أو قديم، نحمل التعديلات
    if (_cachedAdjustments == null ||
        _lastCacheUpdate == null ||
        DateTime.now().difference(_lastCacheUpdate!) > const Duration(minutes: 1)) {
      _cachedAdjustments = await HijriOffsetPrefs.getMonthAdjustments();

      // ✅ نطبق التعديلات الافتراضية لو مش موجودة (شعبان = 30)
      if (!_defaultsApplied) {
        await _applyDefaults();
        _defaultsApplied = true;
      }

      _lastCacheUpdate = DateTime.now();
    }

    final baseDate = HijriDate.now();

    if (_cachedAdjustments == null || _cachedAdjustments!.isEmpty) {
      return HijriDateResult(
        hYear: baseDate.hYear,
        hMonth: baseDate.hMonth,
        hDay: baseDate.hDay,
      );
    }

    return _calculateAdjustedDate(baseDate, _cachedAdjustments!);
  }

  /// تطبيق التعديلات الافتراضية (شعبان = 30 يوم)
  static Future<void> _applyDefaults() async {
    final now = HijriDate.now();
    final String shabanKey = '${now.hYear}-8';

    if (!(_cachedAdjustments?.containsKey(shabanKey) ?? false)) {
      _cachedAdjustments ??= {};
      _cachedAdjustments![shabanKey] = 30;
      await HijriOffsetPrefs.saveMonthAdjustments(_cachedAdjustments!);
    }
  }

  static HijriDateResult _calculateAdjustedDate(
      HijriDate baseDate,
      Map<String, int> adjustments,
      ) {
    int totalDaysAdjustment = 0;

    for (int m = 1; m < baseDate.hMonth; m++) {
      final String monthKey = '${baseDate.hYear}-$m';
      if (adjustments.containsKey(monthKey)) {
        final int adjustedDays = adjustments[monthKey]!;
        final int originalDays = baseDate.getDaysInMonth(baseDate.hYear, m);
        totalDaysAdjustment += (adjustedDays - originalDays);
      }
    }

    if (totalDaysAdjustment == 0) {
      return HijriDateResult(
        hYear: baseDate.hYear,
        hMonth: baseDate.hMonth,
        hDay: baseDate.hDay,
      );
    }

    int newDay = baseDate.hDay - totalDaysAdjustment;
    int newMonth = baseDate.hMonth;
    int newYear = baseDate.hYear;

    while (newDay < 1) {
      newMonth--;
      if (newMonth < 1) {
        newMonth = 12;
        newYear--;
      }
      final String prevKey = '$newYear-$newMonth';
      final int prevMonthDays = adjustments.containsKey(prevKey)
          ? adjustments[prevKey]!
          : HijriDate.now().getDaysInMonth(newYear, newMonth);
      newDay += prevMonthDays;
    }

    while (true) {
      final String curKey = '$newYear-$newMonth';
      final int curMonthDays = adjustments.containsKey(curKey)
          ? adjustments[curKey]!
          : HijriDate.now().getDaysInMonth(newYear, newMonth);
      if (newDay <= curMonthDays) break;
      newDay -= curMonthDays;
      newMonth++;
      if (newMonth > 12) {
        newMonth = 1;
        newYear++;
      }
    }

    return HijriDateResult(hYear: newYear, hMonth: newMonth, hDay: newDay);
  }

  static void clearCache() {
    _cachedAdjustments = null;
    _lastCacheUpdate = null;
    // ✅ مش بنعمل reset لـ _defaultsApplied
    // عشان ما نضيفش شعبان تاني لو اليوزر مسحه يدوياً
    adjustmentNotifier.value++;
  }

  /// مسح كامل شامل الـ defaults (لما اليوزر يعمل reset all)
  static void clearCacheAndDefaults() {
    _cachedAdjustments = null;
    _lastCacheUpdate = null;
    _defaultsApplied = false; // هيضيف شعبان تاني في أول تحميل
    adjustmentNotifier.value++;
  }

  static String getArabicMonthName(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    return months[month - 1];
  }

  static String toArabicNumbers(String input) {
    const english = ['0','1','2','3','4','5','6','7','8','9'];
    const arabic  = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  static Future<String> getFormattedHijriDate({
    bool includeDay = true,
    bool arabicNumbers = true,
  }) async {
    final hijriDate = await getCurrentHijriDate();
    String formatted = includeDay
        ? '${hijriDate.hDay} ${getArabicMonthName(hijriDate.hMonth)} ${hijriDate.hYear}هـ'
        : '${getArabicMonthName(hijriDate.hMonth)} ${hijriDate.hYear}هـ';
    return arabicNumbers ? toArabicNumbers(formatted) : formatted;
  }
}
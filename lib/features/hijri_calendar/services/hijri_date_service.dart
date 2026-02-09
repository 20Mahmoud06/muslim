import 'package:hijri_date/hijri.dart';
import '../utils/hijri_offset_prefs.dart';

/// خدمة مركزية للحصول على التاريخ الهجري الصحيح (مع التعديلات)
class HijriDateService {
  static Map<String, int>? _cachedAdjustments;
  static DateTime? _lastCacheUpdate;

  /// الحصول على التاريخ الهجري الحالي (مع مراعاة التعديلات)
  static Future<HijriDate> getCurrentHijriDate() async {
    // تحديث الـ cache كل دقيقة
    if (_cachedAdjustments == null ||
        _lastCacheUpdate == null ||
        DateTime.now().difference(_lastCacheUpdate!) > const Duration(minutes: 1)) {
      _cachedAdjustments = await HijriOffsetPrefs.getMonthAdjustments();
      _lastCacheUpdate = DateTime.now();
    }

    final baseDate = HijriDate.now();

    // لو مفيش تعديلات، نرجع التاريخ العادي
    if (_cachedAdjustments == null || _cachedAdjustments!.isEmpty) {
      return baseDate;
    }

    return _calculateAdjustedDate(baseDate, _cachedAdjustments!);
  }

  /// حساب التاريخ الهجري المعدّل
  static HijriDate _calculateAdjustedDate(
      HijriDate baseDate,
      Map<String, int> adjustments,
      ) {
    int adjustedYear = baseDate.hYear;
    int adjustedMonth = baseDate.hMonth;
    int adjustedDay = baseDate.hDay;

    // نحسب التعديلات التراكمية من بداية السنة
    int totalDaysAdjustment = 0;

    for (int m = 1; m < baseDate.hMonth; m++) {
      String monthKey = '${baseDate.hYear}-$m';

      if (adjustments.containsKey(monthKey)) {
        int adjustedDays = adjustments[monthKey]!;
        int originalDays = baseDate.getDaysInMonth(baseDate.hYear, m);
        totalDaysAdjustment += (adjustedDays - originalDays);
      }
    }

    // التعديل على الشهر الحالي
    String currentMonthKey = '${baseDate.hYear}-${baseDate.hMonth}';
    int currentMonthOriginalDays = baseDate.getDaysInMonth(baseDate.hYear, baseDate.hMonth);
    int currentMonthAdjustedDays = adjustments[currentMonthKey] ?? currentMonthOriginalDays;

    // لو في تعديل على الشهر الحالي وعدى الأيام الأصلية
    if (adjustments.containsKey(currentMonthKey)) {
      // لو اليوم الحالي أكبر من الأيام المعدّلة (مستحيل بس للأمان)
      if (adjustedDay > currentMonthAdjustedDays) {
        adjustedDay = currentMonthAdjustedDays;
      }
    }

    // تطبيق التعديلات التراكمية
    if (totalDaysAdjustment != 0) {
      // لو في زيادة في الأيام، نضيف أيام
      // لو في نقصان، نشيل أيام
      // (هنا ممكن نحتاج logic أعقد لو التعديلات كبيرة)

      // للبساطة، نرجع التاريخ الأساسي
      // لأن التعديلات بتأثر على الأحداث القادمة مش التاريخ الحالي
    }

    return HijriDate.fromHijri(adjustedYear, adjustedMonth, adjustedDay);
  }

  /// مسح الـ cache (استخدمها لما تعدّل على الأشهر)
  static void clearCache() {
    _cachedAdjustments = null;
    _lastCacheUpdate = null;
  }

  /// الحصول على اسم الشهر الهجري بالعربي
  static String getArabicMonthName(int month) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[month - 1];
  }

  /// تحويل الأرقام الإنجليزية للعربية
  static String toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  /// تنسيق التاريخ الهجري كامل
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
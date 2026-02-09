import '../utils/hijri_offset_prefs.dart';

/// مسؤول عن إدارة التعديلات على الأشهر (التخزين والاسترجاع)
class MonthAdjustmentsRepository {
  Map<String, int> _adjustments = {};

  Map<String, int> get adjustments => Map.unmodifiable(_adjustments);

  /// تحميل التعديلات من التخزين
  Future<void> loadAdjustments() async {
    _adjustments = await HijriOffsetPrefs.getMonthAdjustments();
  }

  /// حفظ التعديلات في التخزين
  Future<void> saveAdjustments() async {
    await HijriOffsetPrefs.saveMonthAdjustments(_adjustments);
  }

  /// تعديل شهر معين
  Future<void> adjustMonth(int year, int month, int days) async {
    String monthKey = '$year-$month';
    _adjustments[monthKey] = days;
    await saveAdjustments();
  }

  /// إزالة تعديل شهر معين
  Future<void> removeAdjustment(int year, int month) async {
    String monthKey = '$year-$month';
    _adjustments.remove(monthKey);
    await saveAdjustments();
  }

  /// مسح جميع التعديلات
  Future<void> clearAll() async {
    _adjustments.clear();
    await HijriOffsetPrefs.resetMonthAdjustments();
  }

  /// التحقق من وجود تعديل على شهر معين
  bool hasAdjustment(int year, int month) {
    String monthKey = '$year-$month';
    return _adjustments.containsKey(monthKey);
  }

  /// الحصول على تعديل شهر معين
  int? getAdjustment(int year, int month) {
    String monthKey = '$year-$month';
    return _adjustments[monthKey];
  }
}
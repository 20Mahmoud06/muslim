import 'package:flutter/cupertino.dart';
import '../services/hijri_date_service.dart';
import '../utils/hijri_offset_prefs.dart';

class MonthAdjustmentsRepository {
  Map<String, int> _adjustments = {};

  Map<String, int> get adjustments => Map.unmodifiable(_adjustments);
  Map<String, int> get manualAdjustments => Map.unmodifiable(_adjustments);

  Future<void> loadAdjustments() async {
    _adjustments = await HijriOffsetPrefs.getMonthAdjustments();
    // الـ HijriDateService هو المسؤول عن إضافة شعبان الافتراضي
    // مش محتاجين نعمله هنا
  }

  bool hasAdjustment(int year, int month) =>
      _adjustments.containsKey('$year-$month');

  int? getAdjustment(int year, int month) => _adjustments['$year-$month'];

  Future<void> adjustMonth(int year, int month, int days) async {
    _adjustments['$year-$month'] = days;
    await HijriOffsetPrefs.saveMonthAdjustments(_adjustments);
    HijriDateService.clearCache();
    debugPrint('✅ تم تعديل $year-$month إلى $days يوم');
  }

  Future<void> removeAdjustment(int year, int month) async {
    _adjustments.remove('$year-$month');
    await HijriOffsetPrefs.saveMonthAdjustments(_adjustments);
    HijriDateService.clearCache();
  }

  Future<void> clearAll() async {
    _adjustments.clear();
    await HijriOffsetPrefs.resetMonthAdjustments();
    // ✅ clearCacheAndDefaults عشان يضيف شعبان تاني بعد الـ reset
    HijriDateService.clearCacheAndDefaults();
  }
}
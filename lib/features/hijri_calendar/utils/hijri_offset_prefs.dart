import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HijriOffsetPrefs {
  static const String _monthAdjustmentsKey = 'hijri_month_adjustments';

  // حفظ تعديلات الأشهر
  static Future<void> saveMonthAdjustments(Map<String, int> adjustments) async {
    final prefs = await SharedPreferences.getInstance();
    // تحويل Map إلى JSON string
    String jsonString = jsonEncode(adjustments);
    await prefs.setString(_monthAdjustmentsKey, jsonString);
  }

  // استرجاع تعديلات الأشهر
  static Future<Map<String, int>> getMonthAdjustments() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_monthAdjustmentsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }

    try {
      Map<String, dynamic> decoded = jsonDecode(jsonString);
      // تحويل dynamic values إلى int
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      return {};
    }
  }

  // إعادة تعيين تعديلات الأشهر
  static Future<void> resetMonthAdjustments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_monthAdjustmentsKey);
  }
}
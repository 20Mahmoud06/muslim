import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HijriOffsetPrefs {
  static const String _monthAdjustmentsKey = 'hijri_month_adjustments';

  static Future<void> saveMonthAdjustments(
      Map<String, int> adjustments) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_monthAdjustmentsKey, jsonEncode(adjustments));
  }

  static Future<Map<String, int>> getMonthAdjustments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_monthAdjustmentsKey);

    if (jsonString == null || jsonString.isEmpty) return {};

    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  static Future<void> resetMonthAdjustments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_monthAdjustmentsKey);
  }
}
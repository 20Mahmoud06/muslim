import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/hadith_model.dart';

class DailyHadithService {
  static const String _hadithIndexKey = 'daily_hadith_index';
  static const String _lastDateKey = 'daily_hadith_date';

  /// تحميل حديث اليوم (عشوائي ويتغير كل يوم)
  static Future<HadithModel?> loadDailyHadith() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month}-${today.day}';
      final lastDate = prefs.getString(_lastDateKey);

      // تحميل الأحاديث من الملف
      final String response = await rootBundle.loadString('assets/data/nawawi40.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> hadithsJson = data['hadiths'] as List<dynamic>;
      final List<HadithModel> hadiths = hadithsJson
          .map((json) => HadithModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (hadiths.isEmpty) return null;

      int hadithIndex;

      // إذا كان اليوم جديد، اختر حديث عشوائي جديد
      if (lastDate != todayString) {
        final random = Random();
        hadithIndex = random.nextInt(hadiths.length);

        // حفظ الحديث المختار وتاريخ اليوم
        await prefs.setInt(_hadithIndexKey, hadithIndex);
        await prefs.setString(_lastDateKey, todayString);
      } else {
        // إذا كنا في نفس اليوم، استرجع نفس الحديث
        hadithIndex = prefs.getInt(_hadithIndexKey) ?? 0;
      }

      return hadiths[hadithIndex];
    } catch (e) {
      print('Error loading daily hadith: $e');
      return null;
    }
  }
}
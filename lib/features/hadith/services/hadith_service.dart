import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/hadith_model.dart';

class HadithService {
  static List<HadithModel>? _cachedHadiths;

  // تحميل الأحاديث من ملف JSON
  static Future<List<HadithModel>> loadHadiths() async {
    // إذا كانت محملة من قبل، ارجعها مباشرة
    if (_cachedHadiths != null) {
      return _cachedHadiths!;
    }

    try {
      // قراءة ملف JSON من assets
      final String jsonString =
      await rootBundle.loadString('assets/data/nawawi40.json');

      // تحويل JSON إلى Map
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // استخراج قائمة الأحاديث
      final List<dynamic> hadithsList = jsonData['hadiths'];

      // تحويل كل حديث إلى كائن HadithModel
      _cachedHadiths = hadithsList
          .map((hadithJson) => HadithModel.fromJson(hadithJson))
          .toList();

      return _cachedHadiths!;
    } catch (e) {
      print('خطأ في تحميل الأحاديث: $e');
      return [];
    }
  }

  // الحصول على حديث معين بالرقم
  static Future<HadithModel?> getHadithByNumber(int number) async {
    try {
      final hadiths = await loadHadiths();
      return hadiths.firstWhere(
            (hadith) => hadith.idInBook == number,
        orElse: () => hadiths.first,
      );
    } catch (e) {
      print('خطأ في الحصول على الحديث: $e');
      return null;
    }
  }

  // الحصول على حديث عشوائي
  static Future<HadithModel?> getRandomHadith() async {
    try {
      final hadiths = await loadHadiths();
      if (hadiths.isEmpty) return null;

      final random = DateTime.now().millisecondsSinceEpoch % hadiths.length;
      return hadiths[random];
    } catch (e) {
      print('خطأ في الحصول على حديث عشوائي: $e');
      return null;
    }
  }

  // الحصول على حديث اليوم (حديث مختلف كل يوم)
  static Future<HadithModel?> getDailyHadith() async {
    try {
      final hadiths = await loadHadiths();
      if (hadiths.isEmpty) return null;

      // حساب رقم اليوم في السنة
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

      // اختيار حديث بناءً على اليوم
      final index = dayOfYear % hadiths.length;
      return hadiths[index];
    } catch (e) {
      print('خطأ في الحصول على حديث اليوم: $e');
      return null;
    }
  }

  // البحث في الأحاديث
  static Future<List<HadithModel>> searchHadiths(String query) async {
    try {
      final hadiths = await loadHadiths();
      if (query.isEmpty) return hadiths;

      return hadiths.where((hadith) {
        return hadith.arabic.contains(query) ||
            hadith.narrator.contains(query) ||
            (hadith.english?.text.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    } catch (e) {
      print('خطأ في البحث: $e');
      return [];
    }
  }

  // مسح الـ cache
  static void clearCache() {
    _cachedHadiths = null;
  }
}
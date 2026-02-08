import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../models/azkar_model.dart';

class DailyAzkarService {
  /// تحميل ذكر اليوم بناءً على الوقت
  static Future<Zikr?> loadDailyZikr() async {
    try {
      final String response = await rootBundle.loadString('assets/data/hisn_almuslim.json');
      final Map<String, dynamic> data = json.decode(response);

      final now = DateTime.now();
      final hour = now.hour;

      // تحديد الفئة المناسبة حسب الوقت
      String categoryKey;

      // من بعد الفجر (5 صباحاً) لقبل الظهر (12 ظهراً) = أذكار الصباح
      if (hour >= 5 && hour < 12) {
        categoryKey = 'أذكار الصباح';
      }
      // من بعد العصر (3 عصراً) لقبل المغرب (6 مساءً) = أذكار المساء
      else if (hour >= 15 && hour < 18) {
        categoryKey = 'أذكار المساء';
      }
      // باقي الأوقات = اختيار عشوائي
      else {
        return _getRandomZikr(data);
      }

      // محاولة جلب الذكر من الفئة المحددة
      if (data.containsKey(categoryKey)) {
        final category = AzkarCategory.fromJson(categoryKey, data[categoryKey]);
        if (category.azkar.isNotEmpty) {
          final random = Random();
          return category.azkar[random.nextInt(category.azkar.length)];
        }
      }

      // إذا لم توجد الفئة أو كانت فارغة، اختر عشوائياً
      return _getRandomZikr(data);
    } catch (e) {
      print('Error loading daily zikr: $e');
      return null;
    }
  }

  /// اختيار ذكر عشوائي من جميع الفئات
  static Zikr? _getRandomZikr(Map<String, dynamic> data) {
    final excludedCategories = ['المقدمة', 'فضل الذكر'];
    final random = Random();

    // جمع جميع الأذكار من الفئات المتاحة
    final List<Zikr> allAzkar = [];

    data.forEach((key, value) {
      if (!excludedCategories.contains(key) && value is Map<String, dynamic>) {
        try {
          final category = AzkarCategory.fromJson(key, value);
          allAzkar.addAll(category.azkar);
        } catch (e) {
          // تجاهل الفئات التي تسبب مشاكل
        }
      }
    });

    if (allAzkar.isEmpty) return null;

    return allAzkar[random.nextInt(allAzkar.length)];
  }

  /// تحميل أذكار الصباح
  static Future<List<Zikr>> loadMorningAzkar() async {
    return _loadAzkarByCategory('أذكار الصباح');
  }

  /// تحميل أذكار المساء
  static Future<List<Zikr>> loadEveningAzkar() async {
    return _loadAzkarByCategory('أذكار المساء');
  }

  /// تحميل أذكار حسب الفئة
  static Future<List<Zikr>> _loadAzkarByCategory(String categoryName) async {
    try {
      final String response = await rootBundle.loadString('assets/data/hisn_almuslim.json');
      final Map<String, dynamic> data = json.decode(response);

      if (data.containsKey(categoryName)) {
        final category = AzkarCategory.fromJson(categoryName, data[categoryName]);
        return category.azkar;
      }

      return [];
    } catch (e) {
      print('Error loading azkar for category $categoryName: $e');
      return [];
    }
  }
}
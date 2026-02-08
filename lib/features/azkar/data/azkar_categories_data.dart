import 'package:flutter/material.dart';

/// بيانات فئات الأذكار الرئيسية
class AzkarCategoriesData {
  static final List<Map<String, dynamic>> mainCategories = [
    {
      'title': 'أذكار الصباح والمساء',
      'icon': Icons.wb_sunny_outlined,
      'gradient': [const Color(0xFF004437), const Color(0xFF006754)],
    },
    {
      'title': 'أذكار النوم',
      'icon': Icons.nightlight_round,
      'gradient': [const Color(0xFF006754), const Color(0xFF158467)],
    },
    {
      'title': 'أذكار الاستيقاظ من النوم',
      'icon': Icons.alarm,
      'gradient': [const Color(0xFF158467), const Color(0xFF87D1A4)],
    },
    {
      'title': 'الأذكار بعد السلام من الصلاة',
      'icon': Icons.mosque,
      'gradient': [const Color(0xFF004437), const Color(0xFF158467)],
    },
    {
      'title': 'دعاء الاستفتاح',
      'icon': Icons.auto_fix_high,
      'gradient': [const Color(0xFF006754), const Color(0xFF87D1A4)],
    },
    {
      'title': 'دعاء الركوع',
      'icon': Icons.south,
      'gradient': [const Color(0xFF004437), const Color(0xFF006754)],
    },
    {
      'title': 'دعاء السجود',
      'icon': Icons.keyboard_arrow_down,
      'gradient': [const Color(0xFF158467), const Color(0xFF87D1A4)],
    },
    {
      'title': 'الذكر عقب السلام من الوتر',
      'icon': Icons.auto_awesome,
      'gradient': [const Color(0xFF006754), const Color(0xFF158467)],
    },
    {
      'title': 'أذكار الأذان',
      'icon': Icons.volume_up,
      'gradient': [const Color(0xFF004437), const Color(0xFF87D1A4)],
    },
    {
      'title': 'الدعاء قبل الطعام',
      'icon': Icons.restaurant,
      'gradient': [const Color(0xFF158467), const Color(0xFF87D1A4)],
    },
    {
      'title': 'دعاء السفر',
      'icon': Icons.flight_takeoff,
      'gradient': [const Color(0xFF006754), const Color(0xFF158467)],
    },
    {
      'title': 'دعاء دخول المسجد',
      'icon': Icons.home_work,
      'gradient': [const Color(0xFF004437), const Color(0xFF158467)],
    },
    {
      'title': 'الاستغفار والتوبة',
      'icon': Icons.refresh,
      'gradient': [const Color(0xFF006754), const Color(0xFF87D1A4)],
    },
    {
      'title': 'فضل التسبيح والتحميد ، والتهليل ، والتكبير',
      'icon': Icons.star,
      'gradient': [const Color(0xFF004437), const Color(0xFF006754)],
    },
  ];

  /// القوائم المستبعدة من JSON
  static const List<String> excludedCategories = [
    'المقدمة',
    'فضل الذكر',
  ];
}
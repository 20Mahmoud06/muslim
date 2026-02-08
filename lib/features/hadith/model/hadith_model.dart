class HadithModel {
  final int id;
  final int idInBook;
  final String arabic;
  final NawawiEnglish? english;

  HadithModel({
    required this.id,
    required this.idInBook,
    required this.arabic,
    this.english,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as int,
      idInBook: json['idInBook'] as int,
      arabic: json['arabic'] as String,
      english: json['english'] != null
          ? NawawiEnglish.fromJson(json['english'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idInBook': idInBook,
      'arabic': arabic,
      'english': english?.toJson(),
    };
  }

  // استخراج الراوي من النص العربي
  String get narrator {
    // البحث عن "عن" في بداية الحديث
    final match = RegExp(r'^عَنْ\s+(.+?)\s+(?:قَالَ|رَضِيَ)').firstMatch(arabic);
    if (match != null) {
      return match.group(1) ?? 'غير محدد';
    }
    return 'غير محدد';
  }

  // استخراج نص الحديث فقط (بدون الراوي والسند)
  String get hadithText {
    // البحث عن النص بين علامات التنصيص
    final match = RegExp(r'"([^"]+)"').firstMatch(arabic);
    if (match != null) {
      return match.group(1) ?? arabic;
    }
    return arabic;
  }

  // استخراج المصدر من نهاية الحديث
  String get source {
    if (arabic.contains('رَوَاهُ')) {
      final match = RegExp(r'رَوَاهُ\s+(.+?)(?:\.|$)').firstMatch(arabic);
      if (match != null) {
        return match.group(1) ?? 'متفق عليه';
      }
    }
    return 'متفق عليه';
  }

  // رقم الحديث بالعربي
  String get numberInArabic {
    const arabicNumbers = [
      'الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس',
      'السادس', 'السابع', 'الثامن', 'التاسع', 'العاشر',
      'الحادي عشر', 'الثاني عشر', 'الثالث عشر', 'الرابع عشر', 'الخامس عشر',
      'السادس عشر', 'السابع عشر', 'الثامن عشر', 'التاسع عشر', 'العشرون',
      'الحادي والعشرون', 'الثاني والعشرون', 'الثالث والعشرون', 'الرابع والعشرون', 'الخامس والعشرون',
      'السادس والعشرون', 'السابع والعشرون', 'الثامن والعشرون', 'التاسع والعشرون', 'الثلاثون',
      'الحادي والثلاثون', 'الثاني والثلاثون', 'الثالث والثلاثون', 'الرابع والثلاثون', 'الخامس والثلاثون',
      'السادس والثلاثون', 'السابع والثلاثون', 'الثامن والثلاثون', 'التاسع والثلاثون', 'الأربعون',
      'الحادي والأربعون', 'الثاني والأربعون'
    ];

    return idInBook > 0 && idInBook <= arabicNumbers.length
        ? arabicNumbers[idInBook - 1]
        : '$idInBook';
  }
}

class NawawiEnglish {
  final String? narrator;
  final String text;

  NawawiEnglish({
    this.narrator,
    required this.text,
  });

  factory NawawiEnglish.fromJson(Map<String, dynamic> json) {
    return NawawiEnglish(
      narrator: json['narrator'] as String?,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'narrator': narrator,
      'text': text,
    };
  }
}
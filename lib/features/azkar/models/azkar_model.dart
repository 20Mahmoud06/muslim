class AzkarCategory {
  final String title;
  final List<Zikr> azkar;

  AzkarCategory({
    required this.title,
    required this.azkar,
  });

  factory AzkarCategory.fromJson(String title, Map<String, dynamic> json) {
    final textList = List<String>.from(json['text'] ?? []);
    final footnoteList = List<String>.from(json['footnote'] ?? []);

    List<Zikr> azkarList = [];
    for (int i = 0; i < textList.length; i++) {
      azkarList.add(Zikr(
        text: textList[i],
        footnote: i < footnoteList.length ? footnoteList[i] : '',
        count: _extractCount(textList[i]),
      ));
    }

    return AzkarCategory(
      title: title,
      azkar: azkarList,
    );
  }

  static int _extractCount(String text) {
    // استخراج العدد من النص مثل (ثلاث مرات) أو (مائة مرة)
    if (text.contains('مائة مرة') || text.contains('مائة مرات')) {
      return 100;
    } else if (text.contains('عشر مرات') || text.contains('عشراً')) {
      return 10;
    } else if (text.contains('سبع مرات')) {
      return 7;
    } else if (text.contains('أربع مرات')) {
      return 4;
    } else if (text.contains('ثلاث مرات') || text.contains('ثلاثاً')) {
      return 3;
    }
    return 1; // مرة واحدة افتراضياً
  }
}

class Zikr {
  final String text;
  final String footnote;
  final int count;
  int currentCount;

  Zikr({
    required this.text,
    required this.footnote,
    required this.count,
  }) : currentCount = 0;

  void increment() {
    if (currentCount < count) {
      currentCount++;
    }
  }

  void reset() {
    currentCount = 0;
  }

  bool get isCompleted => currentCount >= count;
}
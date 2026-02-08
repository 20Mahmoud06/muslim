class TasbihItem {
  final String arabicText;
  final bool isCustom;

  TasbihItem({
    required this.arabicText,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'arabicText': arabicText,
    'isCustom': isCustom,
  };

  factory TasbihItem.fromJson(Map<String, dynamic> json) => TasbihItem(
    arabicText: json['arabicText'] ?? '',
    isCustom: json['isCustom'] ?? false,
  );
}

class TasbihData {
  static List<TasbihItem> defaultTasbihList = [
    TasbihItem(arabicText: 'سُبْحَانَ ٱللَّٰهِ'),
    TasbihItem(arabicText: 'ٱلْحَمْدُ لِلَّٰهِ'),
    TasbihItem(arabicText: 'ٱللَّٰهُ أَكْبَرُ'),
    TasbihItem(arabicText: 'أَسْتَغْفِرُ ٱللَّٰهَ'),
    TasbihItem(arabicText: 'لَآ إِلَٰهَ إِلَّا ٱللَّٰهُ'),
    TasbihItem(arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّٰهِ'),
    TasbihItem(arabicText: 'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ'),
    TasbihItem(arabicText: 'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ\nسُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ'),
    TasbihItem(
        arabicText:
        'ٱللَّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَىٰ سَيِّدِنَا مُحَمَّدٍ وَعَلَىٰ آلِهِ وَصَحْبِهِ أَجْمَعِينَ'),
    TasbihItem(
        arabicText:
        'لَآ إِلَٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ ٱلْمُلْكُ وَلَهُ ٱلْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَىْءٍ قَدِيرٌ'),
    TasbihItem(
        arabicText:
        'لَآ إِلَٰهَ إِلَّآ أَنتَ سُبْحَٰنَكَ إِنِّى كُنتُ مِنَ ٱلظَّٰلِمِينَ'),
    TasbihItem(
        arabicText:
        'لَآ إِلَٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ ٱلْمُلْكُ وَلَهُ ٱلْحَمْدُ يُحْىِۦ وَيُمِيتُ وَهُوَ عَلَىٰ كُلِّ شَىْءٍ قَدِيرٌ'),
    TasbihItem(
        arabicText: 'رَبِّ إِنِّى لِمَآ أَنزَلْتَ إِلَىَّ مِنْ خَيْرٍ فَقِيرٌ'),
    TasbihItem(
        arabicText: 'رَبِّ لَا تَذَرْنِى فَرْدًا وَأَنتَ خَيْرُ ٱلْوَٰرِثِينَ'),
    TasbihItem(
        arabicText:
        'رَبَّنَآ آتِنَا فِى ٱلدُّنْيَا حَسَنَةً وَفِى ٱلْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ ٱلنَّارِ'),
    TasbihItem(
        arabicText:
        'ٱللَّٰهُمَّ أَعِنِّى عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ'),
  ];

  static List<int> defaultGoals = [3, 10, 33, 100, 500, 1000, 3000];
}
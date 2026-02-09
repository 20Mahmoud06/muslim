class HijriEventModel {
  final String title;
  final String arabicTitle;
  final int day;
  final int month;
  final String description;
  final bool isImportant;

  HijriEventModel({
    required this.title,
    required this.arabicTitle,
    required this.day,
    required this.month,
    required this.description,
    this.isImportant = false,
  });

  bool isToday(int currentDay, int currentMonth) {
    return day == currentDay && month == currentMonth;
  }

  // ⭐ هذه الدالة لم تعد تُستخدم - الحساب أصبح في Cubit
  // تركتها للتوافق لو في كود قديم يستخدمها
  int daysUntil(int currentDay, int currentMonth, int lengthOfMonth) {
    if (month == currentMonth) {
      return day - currentDay;
    } else if (month > currentMonth) {
      return (month - currentMonth) * 29 + (day - currentDay);
    } else {
      return (12 - currentMonth + month) * 29 + (day - currentDay);
    }
  }
}
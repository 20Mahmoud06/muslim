import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri_date/hijri.dart';
import '../model/hijri_event_model.dart';
import '../repositories/month_adjustments_repository.dart';
import '../services/hijri_date_calculator.dart';
import '../services/hijri_date_service.dart'; // ⭐ NEW
import '../data/hijri_events_data.dart';

part 'hijri_calendar_state.dart';

class HijriCalendarCubit extends Cubit<HijriCalendarState> {
  HijriCalendarCubit() : super(HijriCalendarInitial()) {
    _initializeCalendar();
  }

  late HijriDate currentDate;
  HijriDate? selectedDate;

  // المستودعات والخدمات
  final _repository = MonthAdjustmentsRepository();
  late HijriDateCalculator _calculator;

  // الأحداث الإسلامية
  final List<HijriEventModel> importantEvents = HijriEventsData.events;

  /// تهيئة التقويم
  Future<void> _initializeCalendar() async {
    HijriDate.setLocal('ar');

    await _repository.loadAdjustments();
    _calculator = HijriDateCalculator(_repository.adjustments);

    currentDate = HijriDate.now();

    _emitLoadedState();
  }

  // ==================== تعديل الأشهر ====================

  /// زيادة عدد أيام الشهر الحالي (من 29 إلى 30)
  Future<void> extendCurrentMonth() async {
    final originalDays = _getOriginalMonthDays(currentDate.hYear, currentDate.hMonth);

    if (originalDays >= 30 && !_repository.hasAdjustment(currentDate.hYear, currentDate.hMonth)) {
      return; // الشهر أصلاً 30 يوم
    }

    await _repository.adjustMonth(currentDate.hYear, currentDate.hMonth, 30);
    await _refreshCalendar();
  }

  /// تقليل عدد أيام الشهر الحالي (من 30 إلى 29)
  Future<void> shortenCurrentMonth() async {
    final originalDays = _getOriginalMonthDays(currentDate.hYear, currentDate.hMonth);

    if (originalDays <= 29 && !_repository.hasAdjustment(currentDate.hYear, currentDate.hMonth)) {
      return; // الشهر أصلاً 29 يوم
    }

    await _repository.adjustMonth(currentDate.hYear, currentDate.hMonth, 29);
    await _refreshCalendar();
  }

  /// إعادة تعيين تعديل الشهر الحالي
  Future<void> resetCurrentMonth() async {
    await _repository.removeAdjustment(currentDate.hYear, currentDate.hMonth);
    await _refreshCalendar();
  }

  /// إعادة تعيين جميع التعديلات
  Future<void> resetAllAdjustments() async {
    await _repository.clearAll();
    await _refreshCalendar();
  }

  // ==================== التنقل في التقويم ====================

  /// اختيار يوم محدد
  void selectDate(int day) {
    final monthLength = _calculator.getAdjustedMonthLength(currentDate.hYear, currentDate.hMonth);
    if (day > monthLength) return;

    selectedDate = HijriDate.fromHijri(currentDate.hYear, currentDate.hMonth, day);
    _emitLoadedState();
  }

  /// إلغاء الاختيار
  void clearSelection() {
    selectedDate = null;
    _emitLoadedState();
  }

  /// تغيير الشهر
  void changeMonth(int direction) {
    currentDate = direction > 0
        ? currentDate.addMonths(1)
        : currentDate.subtractMonths(1);
    selectedDate = null;
    _emitLoadedState();
  }

  /// الذهاب لليوم الحالي
  void goToToday() {
    currentDate = HijriDate.now();
    selectedDate = null;
    _emitLoadedState();
  }

  // ==================== Getters العامة ====================

  /// الحصول على عدد أيام الشهر (مع التعديل)
  int getAdjustedMonthLength(int year, int month) {
    return _calculator.getAdjustedMonthLength(year, month);
  }

  /// الحصول على يوم الأسبوع لأول يوم في الشهر (مع التعديل)
  int getAdjustedFirstWeekday(int year, int month) {
    return _calculator.getAdjustedFirstWeekday(year, month);
  }

  /// الحصول على عدد الأيام حتى حدث معين
  int getDaysUntilEvent(HijriEventModel event) {
    return _calculator.calculateDaysUntilEvent(
      eventDay: event.day,
      eventMonth: event.month,
      currentYear: currentDate.hYear,
      currentMonth: currentDate.hMonth,
      currentDay: currentDate.hDay,
    );
  }

  /// الحصول على الأحداث في يوم محدد
  List<HijriEventModel> getEventsForDay(int day) {
    return importantEvents
        .where((event) => event.day == day && event.month == currentDate.hMonth)
        .toList();
  }

  /// التحقق من وجود حدث في يوم محدد
  bool hasEventOnDay(int day) {
    return importantEvents.any((event) =>
    event.day == day && event.month == currentDate.hMonth);
  }

  /// التحقق من أن اليوم يحتوي على حدث مهم
  bool isImportantDay(int day) {
    return importantEvents.any((event) =>
    event.day == day &&
        event.month == currentDate.hMonth &&
        event.isImportant);
  }

  /// التحقق من أن اليوم هو اليوم الحالي
  bool isToday(int day, int month, int year) {
    final today = HijriDate.now();
    return day == today.hDay && month == today.hMonth && year == today.hYear;
  }

  /// التحقق من وجود تعديل على الشهر الحالي
  bool get hasCurrentMonthAdjustment {
    return _repository.hasAdjustment(currentDate.hYear, currentDate.hMonth);
  }

  /// نوع التعديل على الشهر الحالي
  String? get currentMonthAdjustmentType {
    if (!hasCurrentMonthAdjustment) return null;

    final originalDays = _getOriginalMonthDays(currentDate.hYear, currentDate.hMonth);
    final adjustedDays = _calculator.getAdjustedMonthLength(currentDate.hYear, currentDate.hMonth);

    if (adjustedDays > originalDays) return 'extended';
    if (adjustedDays < originalDays) return 'shortened';
    return null;
  }

  /// عدد الأيام في الشهر الحالي (بعد التعديل)
  int get currentMonthLength {
    return _calculator.getAdjustedMonthLength(currentDate.hYear, currentDate.hMonth);
  }

  // ==================== دوال مساعدة خاصة ====================

  /// تحديث التقويم بعد أي تعديل
  Future<void> _refreshCalendar() async {
    _calculator = HijriDateCalculator(_repository.adjustments);

    // ⭐ مسح الـ cache في الخدمة المركزية
    HijriDateService.clearCache();

    final savedYear = currentDate.hYear;
    final savedMonth = currentDate.hMonth;
    int savedDay = currentDate.hDay;

    // التأكد من أن اليوم ضمن النطاق الجديد
    final newMonthLength = _calculator.getAdjustedMonthLength(savedYear, savedMonth);
    if (savedDay > newMonthLength) {
      savedDay = newMonthLength;
    }

    currentDate = HijriDate.fromHijri(savedYear, savedMonth, savedDay);
    selectedDate = null;

    _emitLoadedState();
  }

  /// الحصول على الأحداث القادمة
  List<HijriEventModel> _getUpcomingEvents() {
    final upcoming = importantEvents.map((event) {
      final daysUntil = getDaysUntilEvent(event);
      return MapEntry(event, daysUntil);
    }).where((entry) {
      return entry.value >= 0 && entry.value <= 60;
    }).toList();

    upcoming.sort((a, b) => a.value.compareTo(b.value));

    return upcoming.take(3).map((entry) => entry.key).toList();
  }

  /// إصدار حالة محملة جديدة
  void _emitLoadedState() {
    emit(HijriCalendarLoaded(
      currentDate: currentDate,
      selectedDate: selectedDate,
      upcomingEvents: _getUpcomingEvents(),
      monthAdjustments: _repository.adjustments,
    ));
  }

  /// الحصول على عدد الأيام الأصلي للشهر (بدون تعديل)
  int _getOriginalMonthDays(int year, int month) {
    final tempDate = HijriDate.now();
    return tempDate.getDaysInMonth(year, month);
  }
}
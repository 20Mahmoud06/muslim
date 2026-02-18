import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri_date/hijri.dart';
import '../model/hijri_date_result.dart';
import '../model/hijri_event_model.dart';
import '../repositories/month_adjustments_repository.dart';
import '../services/hijri_date_calculator.dart';
import '../services/hijri_date_service.dart';
import '../data/hijri_events_data.dart';

part 'hijri_calendar_state.dart';

class HijriCalendarCubit extends Cubit<HijriCalendarState> {
  HijriCalendarCubit() : super(HijriCalendarInitial()) {
    _initializeCalendar();
  }

  // التاريخ المعروض في التقويم (قد يختلف عن اليوم الحقيقي عند التنقل)
  late HijriDate currentDate;
  HijriDate? selectedDate;

  // اليوم الحقيقي المعدّل (للمقارنة في isToday)
  HijriDateResult? _todayAdjusted;

  final _repository = MonthAdjustmentsRepository();
  late HijriDateCalculator _calculator;

  final List<HijriEventModel> importantEvents = HijriEventsData.events;

  Future<void> _initializeCalendar() async {
    HijriDate.setLocal('ar');
    await _repository.loadAdjustments();
    _calculator = HijriDateCalculator(_repository.adjustments);

    // حساب اليوم الحقيقي المعدّل
    _todayAdjusted = await HijriDateService.getCurrentHijriDate();

    // نعرض الشهر الصحيح في التقويم بناءً على اليوم المعدّل
    // لكن currentDate لازم يكون HijriDate صالح من الباكدج
    // نستخدم baseDate (قبل التعديل) للتنقل في التقويم
    currentDate = HijriDate.now();

    // لو التعديل غيّر الشهر (مثلاً من رمضان لشعبان)، نعرض الشهر الصح
    if (_todayAdjusted != null &&
        _todayAdjusted!.hMonth != currentDate.hMonth) {
      // نبدأ بعرض الشهر المعدّل
      currentDate = HijriDate.fromHijri(
        _todayAdjusted!.hYear,
        _todayAdjusted!.hMonth,
        // نستخدم آخر يوم صالح في الشهر المعدّل لو اليوم تجاوز حدود الباكدج
        _getSafeDay(_todayAdjusted!.hYear, _todayAdjusted!.hMonth, _todayAdjusted!.hDay),
      );
    }

    _emitLoadedState();
  }

  /// يرجع يوم آمن للباكدج (مش أكبر من الـ original month length)
  int _getSafeDay(int year, int month, int day) {
    final originalMax = HijriDate.now().getDaysInMonth(year, month);
    return day > originalMax ? originalMax : day;
  }

  // ==================== تعديل الأشهر ====================

  Future<void> extendCurrentMonth() async {
    await _repository.adjustMonth(currentDate.hYear, currentDate.hMonth, 30);
    await _refreshCalendar();
  }

  Future<void> shortenCurrentMonth() async {
    await _repository.adjustMonth(currentDate.hYear, currentDate.hMonth, 29);
    await _refreshCalendar();
  }

  Future<void> resetCurrentMonth() async {
    await _repository.removeAdjustment(currentDate.hYear, currentDate.hMonth);
    await _refreshCalendar();
  }

  Future<void> resetAllAdjustments() async {
    await _repository.clearAll();
    await _refreshCalendar();
  }

  // ==================== التنقل ====================

  void selectDate(int day) {
    final monthLength = _calculator.getAdjustedMonthLength(
        currentDate.hYear, currentDate.hMonth);
    if (day > monthLength) return;

    final safeDay = _getSafeDay(currentDate.hYear, currentDate.hMonth, day);
    selectedDate = HijriDate.fromHijri(currentDate.hYear, currentDate.hMonth, safeDay);
    _emitLoadedState();
  }

  void clearSelection() {
    selectedDate = null;
    _emitLoadedState();
  }

  void changeMonth(int direction) {
    currentDate = direction > 0
        ? currentDate.addMonths(1)
        : currentDate.subtractMonths(1);
    selectedDate = null;
    _emitLoadedState();
  }

  Future<void> goToToday() async {
    _todayAdjusted = await HijriDateService.getCurrentHijriDate();
    if (_todayAdjusted != null) {
      currentDate = HijriDate.fromHijri(
        _todayAdjusted!.hYear,
        _todayAdjusted!.hMonth,
        _getSafeDay(_todayAdjusted!.hYear, _todayAdjusted!.hMonth, _todayAdjusted!.hDay),
      );
    } else {
      currentDate = HijriDate.now();
    }
    selectedDate = null;
    _emitLoadedState();
  }

  // ==================== Getters ====================

  int getAdjustedMonthLength(int year, int month) =>
      _calculator.getAdjustedMonthLength(year, month);

  int getAdjustedFirstWeekday(int year, int month) =>
      _calculator.getAdjustedFirstWeekday(year, month);

  int getDaysUntilEvent(HijriEventModel event) {
    // استخدام اليوم المعدّل الحقيقي للحسابات
    final today = _todayAdjusted;
    if (today == null) return event.daysUntil(currentDate.hDay, currentDate.hMonth, 30);

    return _calculator.calculateDaysUntilEvent(
      eventDay: event.day,
      eventMonth: event.month,
      currentYear: today.hYear,
      currentMonth: today.hMonth,
      currentDay: today.hDay,
    );
  }

  List<HijriEventModel> getEventsForDay(int day) {
    return importantEvents
        .where((e) => e.day == day && e.month == currentDate.hMonth)
        .toList();
  }

  bool hasEventOnDay(int day) {
    return importantEvents
        .any((e) => e.day == day && e.month == currentDate.hMonth);
  }

  bool isImportantDay(int day) {
    return importantEvents.any((e) =>
    e.day == day && e.month == currentDate.hMonth && e.isImportant);
  }

  /// المقارنة باليوم الحقيقي المعدّل
  bool isToday(int day, int month, int year) {
    final today = _todayAdjusted;
    if (today == null) return false;
    return day == today.hDay && month == today.hMonth && year == today.hYear;
  }

  bool get hasCurrentMonthAdjustment =>
      _repository.hasAdjustment(currentDate.hYear, currentDate.hMonth);

  String? get currentMonthAdjustmentType {
    if (!hasCurrentMonthAdjustment) return null;
    final originalDays = _getOriginalMonthDays(currentDate.hYear, currentDate.hMonth);
    final adjustedDays = _calculator.getAdjustedMonthLength(currentDate.hYear, currentDate.hMonth);
    if (adjustedDays > originalDays) return 'extended';
    if (adjustedDays < originalDays) return 'shortened';
    return null;
  }

  int get currentMonthLength =>
      _calculator.getAdjustedMonthLength(currentDate.hYear, currentDate.hMonth);

  // ==================== دوال مساعدة ====================

  Future<void> _refreshCalendar() async {
    _calculator = HijriDateCalculator(_repository.adjustments);
    HijriDateService.clearCache();

    _todayAdjusted = await HijriDateService.getCurrentHijriDate();

    // نحافظ على الشهر المعروض
    final savedYear = currentDate.hYear;
    final savedMonth = currentDate.hMonth;
    int savedDay = currentDate.hDay;

    final newMonthLength = _calculator.getAdjustedMonthLength(savedYear, savedMonth);
    if (savedDay > newMonthLength) savedDay = newMonthLength;

    // نستخدم يوم آمن للباكدج
    final safeDay = _getSafeDay(savedYear, savedMonth, savedDay);
    currentDate = HijriDate.fromHijri(savedYear, savedMonth, safeDay);
    selectedDate = null;

    _emitLoadedState();
  }

  List<HijriEventModel> _getUpcomingEvents() {
    final today = _todayAdjusted;
    if (today == null) return [];

    final upcoming = importantEvents.map((event) {
      final daysUntil = _calculator.calculateDaysUntilEvent(
        eventDay: event.day,
        eventMonth: event.month,
        currentYear: today.hYear,
        currentMonth: today.hMonth,
        currentDay: today.hDay,
      );
      return MapEntry(event, daysUntil);
    }).where((entry) => entry.value >= 0 && entry.value <= 60).toList();

    upcoming.sort((a, b) => a.value.compareTo(b.value));
    return upcoming.take(3).map((e) => e.key).toList();
  }

  void _emitLoadedState() {
    emit(HijriCalendarLoaded(
      currentDate: currentDate,
      selectedDate: selectedDate,
      upcomingEvents: _getUpcomingEvents(),
      monthAdjustments: _repository.manualAdjustments,
    ));
  }

  int _getOriginalMonthDays(int year, int month) {
    return HijriDate.now().getDaysInMonth(year, month);
  }
}
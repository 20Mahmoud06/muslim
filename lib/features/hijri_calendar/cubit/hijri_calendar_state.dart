part of 'hijri_calendar_cubit.dart';

abstract class HijriCalendarState {}

class HijriCalendarInitial extends HijriCalendarState {}

class HijriCalendarLoaded extends HijriCalendarState {
  final HijriDate currentDate;
  final HijriDate? selectedDate;
  final List<HijriEventModel> upcomingEvents;

  HijriCalendarLoaded({
    required this.currentDate,
    required this.selectedDate,
    required this.upcomingEvents,
  });
}
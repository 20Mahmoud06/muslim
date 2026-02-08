import 'package:equatable/equatable.dart';
import '../models/prayer_times_model.dart';

abstract class PrayerTimesState extends Equatable {
  const PrayerTimesState();

  @override
  List<Object?> get props => [];
}

class PrayerTimesInitial extends PrayerTimesState {}

class PrayerTimesLoading extends PrayerTimesState {}

class PrayerTimesLoaded extends PrayerTimesState {
  final PrayerTimesModel prayerTimes;
  final String cityName;
  final Map<String, bool> notificationSettings;

  const PrayerTimesLoaded({
    required this.prayerTimes,
    required this.cityName,
    required this.notificationSettings,
  });

  PrayerTimesLoaded copyWith({
    PrayerTimesModel? prayerTimes,
    String? cityName,
    Map<String, bool>? notificationSettings,
  }) {
    return PrayerTimesLoaded(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      cityName: cityName ?? this.cityName,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }

  @override
  List<Object?> get props => [prayerTimes, cityName, notificationSettings];
}

class PrayerTimesError extends PrayerTimesState {
  final String message;
  final bool isLocationPermissionError;

  const PrayerTimesError({
    required this.message,
    this.isLocationPermissionError = false,
  });

  @override
  List<Object?> get props => [message, isLocationPermissionError];
}

class PrayerTimesNotificationUpdated extends PrayerTimesState {
  final String message;

  const PrayerTimesNotificationUpdated(this.message);

  @override
  List<Object?> get props => [message];
}
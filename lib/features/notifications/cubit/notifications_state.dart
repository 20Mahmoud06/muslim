import 'package:equatable/equatable.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object?> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final bool prayerNotificationsEnabled;
  final bool fridayKahfEnabled;
  final bool nightMulkEnabled;
  final bool dailyWirdEnabled;

  const NotificationSettingsLoaded({
    required this.prayerNotificationsEnabled,
    required this.fridayKahfEnabled,
    required this.nightMulkEnabled,
    required this.dailyWirdEnabled,
  });

  NotificationSettingsLoaded copyWith({
    bool? prayerNotificationsEnabled,
    bool? fridayKahfEnabled,
    bool? nightMulkEnabled,
    bool? dailyWirdEnabled,
  }) {
    return NotificationSettingsLoaded(
      prayerNotificationsEnabled:
      prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      fridayKahfEnabled: fridayKahfEnabled ?? this.fridayKahfEnabled,
      nightMulkEnabled: nightMulkEnabled ?? this.nightMulkEnabled,
      dailyWirdEnabled: dailyWirdEnabled ?? this.dailyWirdEnabled,
    );
  }

  @override
  List<Object?> get props => [
    prayerNotificationsEnabled,
    fridayKahfEnabled,
    nightMulkEnabled,
    dailyWirdEnabled,
  ];
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationSettingsSuccess extends NotificationSettingsState {
  final String message;

  const NotificationSettingsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/features/notifications/cubit/notifications_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../constants/notification_constants.dart';
import '../services/notification_service.dart';
import '../../prayer_times/services/prayer_times_service.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit() : super(NotificationSettingsInitial());

  Future<void> loadSettings() async {
    emit(NotificationSettingsLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      emit(NotificationSettingsLoaded(
        prayerNotificationsEnabled:
        prefs.getBool(NotificationConstants.prayerNotificationsKey) ?? true,
        fridayKahfEnabled:
        prefs.getBool(NotificationConstants.fridayKahfKey) ?? true,
        nightMulkEnabled:
        prefs.getBool(NotificationConstants.nightMulkKey) ?? true,
        dailyWirdEnabled:
        prefs.getBool(NotificationConstants.dailyWirdKey) ?? true,
      ));
    } catch (e) {
      emit(NotificationSettingsError('فشل تحميل الإعدادات: ${e.toString()}'));
    }
  }

  Future<void> togglePrayerNotifications(bool value) async {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(NotificationConstants.prayerNotificationsKey, value);

      emit(currentState.copyWith(prayerNotificationsEnabled: value));

      if (value) {
        await _reschedulePrayerNotifications();
        emit(const NotificationSettingsSuccess('تم تفعيل إشعارات الصلاة 🕌'));
      } else {
        await NotificationService.cancelPrayerNotifications();
        emit(const NotificationSettingsSuccess('تم إلغاء إشعارات الصلاة'));
      }

      // العودة للحالة الأساسية بعد إظهار الرسالة
      emit(currentState.copyWith(prayerNotificationsEnabled: value));
    } catch (e) {
      emit(NotificationSettingsError('فشل تحديث إشعارات الصلاة: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> toggleFridayKahf(bool value) async {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(NotificationConstants.fridayKahfKey, value);

      emit(currentState.copyWith(fridayKahfEnabled: value));

      if (value) {
        await NotificationService.scheduleDailyReminders();
        emit(const NotificationSettingsSuccess('تم تفعيل تذكير سورة الكهف 📖'));
      } else {
        await AwesomeNotifications().cancel(NotificationConstants.fridayKahfId);
        emit(const NotificationSettingsSuccess('تم إلغاء تذكير سورة الكهف'));
      }

      emit(currentState.copyWith(fridayKahfEnabled: value));
    } catch (e) {
      emit(NotificationSettingsError('فشل تحديث تذكير الكهف: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> toggleNightMulk(bool value) async {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(NotificationConstants.nightMulkKey, value);

      emit(currentState.copyWith(nightMulkEnabled: value));

      if (value) {
        await NotificationService.scheduleDailyReminders();
        emit(const NotificationSettingsSuccess('تم تفعيل تذكير سورة الملك 🌙'));
      } else {
        await AwesomeNotifications().cancel(NotificationConstants.nightMulkId);
        emit(const NotificationSettingsSuccess('تم إلغاء تذكير سورة الملك'));
      }

      emit(currentState.copyWith(nightMulkEnabled: value));
    } catch (e) {
      emit(NotificationSettingsError('فشل تحديث تذكير الملك: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> toggleDailyWird(bool value) async {
    if (state is! NotificationSettingsLoaded) return;

    final currentState = state as NotificationSettingsLoaded;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(NotificationConstants.dailyWirdKey, value);

      emit(currentState.copyWith(dailyWirdEnabled: value));

      if (value) {
        await NotificationService.scheduleDailyReminders();
        emit(const NotificationSettingsSuccess('تم تفعيل تذكير الورد اليومي 📿'));
      } else {
        await AwesomeNotifications().cancel(NotificationConstants.dailyWirdId);
        emit(const NotificationSettingsSuccess('تم إلغاء تذكير الورد اليومي'));
      }

      emit(currentState.copyWith(dailyWirdEnabled: value));
    } catch (e) {
      emit(NotificationSettingsError('فشل تحديث الورد اليومي: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _reschedulePrayerNotifications() async {
    final savedLocation = await PrayerTimesService.getSavedLocation();
    if (savedLocation != null) {
      final prayerTimes = await PrayerTimesService.calculatePrayerTimes(
        latitude: savedLocation['latitude'],
        longitude: savedLocation['longitude'],
      );
      if (prayerTimes != null) {
        await NotificationService.schedulePrayerNotifications(prayerTimes);
      }
    }
  }
}
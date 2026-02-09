import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/prayer_times_service.dart';
import '../../notifications/services/notification_service.dart';
import 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit() : super(PrayerTimesInitial());

  Future<void> loadPrayerTimes() async {
    emit(PrayerTimesLoading());

    try {
      // فحص صلاحيات الموقع
      final hasPermission = await PrayerTimesService.requestLocationPermission();

      if (!hasPermission) {
        emit(const PrayerTimesError(
          message: 'يرجى السماح بالوصول للموقع',
          isLocationPermissionError: true,
        ));
        return;
      }

      // تحميل إعدادات الإشعارات
      final notificationSettings = await _loadNotificationSettings();

      // استخدام checkAndUpdateLocation للتحديث التلقائي
      final location = await PrayerTimesService.checkAndUpdateLocation();

      if (location == null) {
        emit(const PrayerTimesError(message: 'فشل تحديد الموقع'));
        return;
      }

      // حساب مواقيت الصلاة
      final prayerTimes = await PrayerTimesService.calculatePrayerTimes(
        latitude: location['latitude'],
        longitude: location['longitude'],
        scheduleNotifications: true,
      );

      if (prayerTimes == null) {
        emit(const PrayerTimesError(message: 'خطأ في حساب المواقيت'));
        return;
      }

      emit(PrayerTimesLoaded(
        prayerTimes: prayerTimes,
        cityName: location['city'] ?? 'موقعك الحالي',
        notificationSettings: notificationSettings,
      ));

    } catch (e) {
      emit(PrayerTimesError(message: 'خطأ في التحميل: ${e.toString()}'));
    }
  }

  Future<Map<String, bool>> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fajr': prefs.getBool('notify_fajr') ?? true,
      'dhuhr': prefs.getBool('notify_dhuhr') ?? true,
      'asr': prefs.getBool('notify_asr') ?? true,
      'maghrib': prefs.getBool('notify_maghrib') ?? true,
      'isha': prefs.getBool('notify_isha') ?? true,
    };
  }

  Future<void> togglePrayerNotification(String prayerKey, bool enabled) async {
    if (state is! PrayerTimesLoaded) return;

    final currentState = state as PrayerTimesLoaded;

    try {
      // حفظ الإعداد
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notify_$prayerKey', enabled);

      // تحديث الإعدادات المحلية
      final updatedSettings = Map<String, bool>.from(currentState.notificationSettings);
      updatedSettings[prayerKey] = enabled;

      emit(currentState.copyWith(notificationSettings: updatedSettings));

      // إعادة جدولة الإشعارات
      await NotificationService.schedulePrayerNotifications(currentState.prayerTimes);

      // إظهار رسالة النجاح
      final prayerNames = {
        'fajr': 'الفجر',
        'dhuhr': 'الظهر',
        'asr': 'العصر',
        'maghrib': 'المغرب',
        'isha': 'العشاء',
      };
      final prayerName = prayerNames[prayerKey] ?? prayerKey;

      emit(PrayerTimesNotificationUpdated(
        enabled ? 'تم تفعيل إشعار $prayerName' : 'تم إيقاف إشعار $prayerName',
      ));

      // العودة للحالة المحدّثة
      emit(currentState.copyWith(notificationSettings: updatedSettings));

    } catch (e) {
      emit(PrayerTimesError(message: 'فشل تحديث الإشعار: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> refreshPrayerTimes() async {
    await loadPrayerTimes();
  }
}
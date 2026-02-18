import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../prayer_times/models/prayer_times_model.dart';
import '../constants/notification_constants.dart';

class NotificationService {
  /// تهيئة الإشعارات
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        // قناة إشعارات الصلاة
        NotificationChannel(
          channelKey: NotificationConstants.prayerChannelKey,
          channelName: 'مواقيت الصلاة',
          channelDescription: 'إشعارات أوقات الصلاة الخمسة',
          defaultColor: const Color(0xFF004437),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          vibrationPattern: lowVibrationPattern,
          enableLights: true,
          channelShowBadge: true,
          onlyAlertOnce: false,
          criticalAlerts: false,
          locked: false,
        ),
        // قناة التذكيرات اليومية
        NotificationChannel(
          channelKey: NotificationConstants.dailyChannelKey,
          channelName: 'التذكيرات اليومية',
          channelDescription: 'تذكيرات القرآن والأذكار اليومية',
          defaultColor: const Color(0xFF006754),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          vibrationPattern: lowVibrationPattern,
          enableLights: true,
          channelShowBadge: true,
        ),
      ],
    );

    await requestPermissions();
  }

  static Future<bool> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  /// جدولة إشعارات الصلاة (متكررة يومياً)
  static Future<void> schedulePrayerNotifications(
      PrayerTimesModel prayerTimes) async {
    await cancelPrayerNotifications();

    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        NotificationConstants.lastPrayerScheduleDateKey, now.toString());

    // جدولة كل الصلوات
    await _scheduleDailyPrayerNotification(
      id: NotificationConstants.fajrNotificationId,
      title: 'حان الآن موعد صلاة الفجر',
      body: 'الصلاة خير من النوم 🌅',
      hour: prayerTimes.fajr.hour,
      minute: prayerTimes.fajr.minute,
    );

    await _scheduleDailyPrayerNotification(
      id: NotificationConstants.dhuhrNotificationId,
      title: 'حان الآن موعد صلاة الظهر',
      body: 'حي على الصلاة 🕌',
      hour: prayerTimes.dhuhr.hour,
      minute: prayerTimes.dhuhr.minute,
    );

    await _scheduleDailyPrayerNotification(
      id: NotificationConstants.asrNotificationId,
      title: 'حان الآن موعد صلاة العصر',
      body: 'حي على الصلاة 🕌',
      hour: prayerTimes.asr.hour,
      minute: prayerTimes.asr.minute,
    );

    await _scheduleDailyPrayerNotification(
      id: NotificationConstants.maghribNotificationId,
      title: 'حان الآن موعد صلاة المغرب',
      body: 'حي على الصلاة 🕌',
      hour: prayerTimes.maghrib.hour,
      minute: prayerTimes.maghrib.minute,
    );

    await _scheduleDailyPrayerNotification(
      id: NotificationConstants.ishaNotificationId,
      title: 'حان الآن موعد صلاة العشاء',
      body: 'حي على الصلاة 🕌',
      hour: prayerTimes.isha.hour,
      minute: prayerTimes.isha.minute,
    );

    debugPrint('✅ تم جدولة إشعارات الصلاة الخمسة (متكررة يوميًا)');
    debugPrint('   الفجر: ${prayerTimes.fajr.hour}:${prayerTimes.fajr.minute}');
    debugPrint('   الظهر: ${prayerTimes.dhuhr.hour}:${prayerTimes.dhuhr.minute}');
    debugPrint('   العصر: ${prayerTimes.asr.hour}:${prayerTimes.asr.minute}');
    debugPrint(
        '   المغرب: ${prayerTimes.maghrib.hour}:${prayerTimes.maghrib.minute}');
    debugPrint('   العشاء: ${prayerTimes.isha.hour}:${prayerTimes.isha.minute}');
  }

  static Future<void> _scheduleDailyPrayerNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: NotificationConstants.prayerChannelKey,
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          fullScreenIntent: false,
          category: NotificationCategory.Reminder,
          criticalAlert: false,
          autoDismissible: true,
          backgroundColor: const Color(0xFF004437),
          color: Colors.white,
          locked: false,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
          preciseAlarm: true,
        ),
      );
    } catch (e) {
      debugPrint('❌ خطأ في جدولة إشعار $title: $e');
    }
  }

  /// جدولة التذكيرات اليومية
  static Future<void> scheduleDailyReminders() async {
    await cancelDailyReminders();

    final prefs = await SharedPreferences.getInstance();

    final fridayKahfEnabled =
        prefs.getBool(NotificationConstants.fridayKahfKey) ?? true;
    if (fridayKahfEnabled) {
      try {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: NotificationConstants.fridayKahfId,
            channelKey: NotificationConstants.dailyChannelKey,
            title: '📖 لا تنسَ قراءة سورة الكهف',
            body:
            'اللهم صل وسلم على نبينا محمد ﷺ\nمن قرأ سورة الكهف يوم الجمعة أضاء له من النور ما بين الجمعتين',
            notificationLayout: NotificationLayout.BigText,
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            autoDismissible: true,
          ),
          schedule: NotificationCalendar(
            weekday: 5,
            hour: 10,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: true,
          ),
        );
        debugPrint('✅ تم جدولة تذكير سورة الكهف');
      } catch (e) {
        debugPrint('❌ خطأ في جدولة سورة الكهف: $e');
      }
    }

    final nightMulkEnabled =
        prefs.getBool(NotificationConstants.nightMulkKey) ?? true;
    if (nightMulkEnabled) {
      try {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: NotificationConstants.nightMulkId,
            channelKey: NotificationConstants.dailyChannelKey,
            title: '🌙 لا تنسَ قراءة سورة الملك',
            body:
            'تبارك الذي بيده الملك وهو على كل شيء قدير\nسورة الملك تنجي من عذاب القبر',
            notificationLayout: NotificationLayout.BigText,
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            autoDismissible: true,
          ),
          schedule: NotificationCalendar(
            hour: 23,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: true,
          ),
        );
        debugPrint('✅ تم جدولة تذكير سورة الملك');
      } catch (e) {
        debugPrint('❌ خطأ في جدولة سورة الملك: $e');
      }
    }

    final dailyWirdEnabled =
        prefs.getBool(NotificationConstants.dailyWirdKey) ?? true;
    if (dailyWirdEnabled) {
      try {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: NotificationConstants.dailyWirdId,
            channelKey: NotificationConstants.dailyChannelKey,
            title: '📿 لا تنسَ الورد اليومي والأذكار',
            body: 'واذكر ربك في نفسك تضرعاً وخيفة\nحافظ على أذكارك اليومية وأورادك',
            notificationLayout: NotificationLayout.BigText,
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            autoDismissible: true,
          ),
          schedule: NotificationCalendar(
            hour: 13,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: true,
          ),
        );
        debugPrint('✅ تم جدولة تذكير الورد اليومي');
      } catch (e) {
        debugPrint('❌ خطأ في جدولة الورد اليومي: $e');
      }
    }

    debugPrint('✅ تم جدولة التذكيرات اليومية');
  }

  static Future<void> cancelPrayerNotifications() async {
    await AwesomeNotifications()
        .cancel(NotificationConstants.fajrNotificationId);
    await AwesomeNotifications()
        .cancel(NotificationConstants.dhuhrNotificationId);
    await AwesomeNotifications()
        .cancel(NotificationConstants.asrNotificationId);
    await AwesomeNotifications()
        .cancel(NotificationConstants.maghribNotificationId);
    await AwesomeNotifications()
        .cancel(NotificationConstants.ishaNotificationId);
    debugPrint('✅ تم إلغاء إشعارات الصلاة');
  }

  static Future<void> cancelDailyReminders() async {
    await AwesomeNotifications().cancel(NotificationConstants.fridayKahfId);
    await AwesomeNotifications().cancel(NotificationConstants.nightMulkId);
    await AwesomeNotifications().cancel(NotificationConstants.dailyWirdId);
    debugPrint('✅ تم إلغاء التذكيرات اليومية');
  }

  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    debugPrint('✅ تم إلغاء كل الإشعارات');
  }

  static Future<List<NotificationModel>> getScheduledNotifications() async {
    final notifications =
    await AwesomeNotifications().listScheduledNotifications();
    debugPrint('📋 عدد الإشعارات المجدولة: ${notifications.length}');
    for (var notif in notifications) {
      debugPrint('   - ${notif.content?.title}');
    }
    return notifications;
  }
}
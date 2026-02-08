import 'package:adhan_dart/adhan_dart.dart';

class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String currentPrayer;
  final String nextPrayer;
  final DateTime? nextPrayerTime;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.currentPrayer,
    required this.nextPrayer,
    this.nextPrayerTime,
  });

  /// تحويل من UTC للتوقيت المحلي
  static DateTime _toLocalTime(DateTime utcTime) {
    // المكتبة بترجع الأوقات بـ UTC، لازم نحولها للتوقيت المحلي
    if (utcTime.isUtc) {
      return utcTime.toLocal();
    }
    // لو مش UTC، نرجعها زي ما هي
    return utcTime;
  }

  factory PrayerTimesModel.fromPrayerTimes(PrayerTimes prayerTimes) {
    final current = prayerTimes.currentPrayer(date: DateTime.now());
    final next = prayerTimes.nextPrayer();

    return PrayerTimesModel(
      // ⭐ تحويل كل الأوقات للتوقيت المحلي
      fajr: _toLocalTime(prayerTimes.fajr),
      sunrise: _toLocalTime(prayerTimes.sunrise),
      dhuhr: _toLocalTime(prayerTimes.dhuhr),
      asr: _toLocalTime(prayerTimes.asr),
      maghrib: _toLocalTime(prayerTimes.maghrib),
      isha: _toLocalTime(prayerTimes.isha),

      currentPrayer: current.name ?? '',
      nextPrayer: next.name ?? '',

      // ⭐ تحويل وقت الصلاة القادمة للتوقيت المحلي
      nextPrayerTime: prayerTimes.timeForPrayer(next) != null
          ? _toLocalTime(prayerTimes.timeForPrayer(next)!)
          : null,
    );
  }

  // الحصول على وقت الصلاة حسب الاسم
  DateTime? getTimeForPrayer(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return fajr;
      case 'sunrise':
        return sunrise;
      case 'dhuhr':
        return dhuhr;
      case 'asr':
        return asr;
      case 'maghrib':
        return maghrib;
      case 'isha':
        return isha;
      default:
        return null;
    }
  }

  // التحقق من أن الصلاة الحالية
  bool isCurrentPrayer(String prayerName) {
    final cleanCurrentPrayer = currentPrayer.toLowerCase().replaceAll('after', '');
    return cleanCurrentPrayer == prayerName.toLowerCase();
  }

  // التحقق من أن الصلاة القادمة
  bool isNextPrayer(String prayerName) {
    final cleanNextPrayer = nextPrayer.toLowerCase().replaceAll('after', '');
    return cleanNextPrayer == prayerName.toLowerCase();
  }
}
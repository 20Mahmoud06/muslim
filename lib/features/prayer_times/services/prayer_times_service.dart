import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times_model.dart';
import '../../notifications/services/notification_service.dart';

class PrayerTimesService {
  static const String _latKey = 'saved_latitude';
  static const String _lonKey = 'saved_longitude';
  static const String _cityKey = 'saved_city';
  static const String _lastCalculatedDateKey = 'last_calculated_date';
  static const String _lastLocationCheckKey = 'last_location_check';
  static const double _locationUpdateThresholdKm = 50.0;

  static Future<bool> requestLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ خدمات الموقع غير مفعلة');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ تم رفض صلاحيات الموقع');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ صلاحيات الموقع مرفوضة بشكل دائم');
        return false;
      }

      debugPrint('✅ تم منح صلاحيات الموقع بنجاح');
      return true;
    } catch (e) {
      debugPrint('خطأ في طلب صلاحيات الموقع: $e');
      return false;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('✅ تم الحصول على الموقع: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('خطأ في الحصول على الموقع: $e');
      return null;
    }
  }

  static Future<String?> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        String cityName = placemark.locality ??
            placemark.administrativeArea ??
            placemark.country ??
            'موقعك الحالي';

        cityName = cityName
            .replaceAll(' Governorate', '')
            .replaceAll('محافظة ', '')
            .trim();

        debugPrint('✅ اسم المدينة: $cityName');
        return cityName;
      }
      return null;
    } catch (e) {
      debugPrint('خطأ في الحصول على اسم المدينة: $e');
      return null;
    }
  }

  static Future<void> saveLocation(double lat, double lon, String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, lat);
      await prefs.setDouble(_lonKey, lon);
      await prefs.setString(_cityKey, city);
      await prefs.setInt(_lastLocationCheckKey, DateTime.now().millisecondsSinceEpoch);
      debugPrint('✅ تم حفظ الموقع: $city');
    } catch (e) {
      debugPrint('خطأ في حفظ الموقع: $e');
    }
  }

  static Future<Map<String, dynamic>?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_latKey);
      final lon = prefs.getDouble(_lonKey);
      final city = prefs.getString(_cityKey);

      if (lat != null && lon != null) {
        debugPrint('✅ تم استرجاع الموقع المحفوظ: $city');
        return {
          'latitude': lat,
          'longitude': lon,
          'city': city ?? 'موقعك الحالي',
        };
      }
      return null;
    } catch (e) {
      debugPrint('خطأ في استرجاع الموقع المحفوظ: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> checkAndUpdateLocation() async {
    try {
      final savedLocation = await getSavedLocation();
      final currentPosition = await getCurrentLocation();

      if (currentPosition == null) {
        debugPrint('⚠️ لا يمكن الحصول على الموقع الحالي');
        return savedLocation;
      }

      if (savedLocation == null) {
        final cityName = await getCityName(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        await saveLocation(
          currentPosition.latitude,
          currentPosition.longitude,
          cityName ?? 'موقعك الحالي',
        );
        return {
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'city': cityName ?? 'موقعك الحالي',
        };
      }

      final distance = Geolocator.distanceBetween(
        savedLocation['latitude'],
        savedLocation['longitude'],
        currentPosition.latitude,
        currentPosition.longitude,
      );

      final distanceKm = distance / 1000;

      debugPrint('📍 المسافة بين الموقع المحفوظ والحالي: ${distanceKm.toStringAsFixed(2)} كم');

      if (distanceKm > _locationUpdateThresholdKm) {
        debugPrint('🔄 الموقع تغير بشكل كبير، جاري التحديث...');
        final cityName = await getCityName(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        await saveLocation(
          currentPosition.latitude,
          currentPosition.longitude,
          cityName ?? 'موقعك الحالي',
        );

        return {
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'city': cityName ?? 'موقعك الحالي',
        };
      }

      return savedLocation;

    } catch (e) {
      debugPrint('خطأ في فحص وتحديث الموقع: $e');
      return await getSavedLocation();
    }
  }

  static Future<PrayerTimesModel?> calculatePrayerTimes({
    required double latitude,
    required double longitude,
    bool scheduleNotifications = true,
  }) async {
    try {
      final coordinates = Coordinates(latitude, longitude);
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day);

      debugPrint('📅 التاريخ المستخدم: $date');
      debugPrint('🕐 الوقت الحالي: $now');

      final params = CalculationMethodParameters.egyptian();
      params.madhab = Madhab.shafi;

      final prayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: date,
        calculationParameters: params,
        precision: true,
      );

      final model = PrayerTimesModel.fromPrayerTimes(prayerTimes);

      debugPrint('✅ تم حساب مواقيت الصلاة بنجاح');
      debugPrint('   الفجر: ${model.fajr} (${model.fajr.hour}:${model.fajr.minute})');
      debugPrint('   الظهر: ${model.dhuhr} (${model.dhuhr.hour}:${model.dhuhr.minute})');
      debugPrint('   العصر: ${model.asr} (${model.asr.hour}:${model.asr.minute})');
      debugPrint('   المغرب: ${model.maghrib} (${model.maghrib.hour}:${model.maghrib.minute})');
      debugPrint('   العشاء: ${model.isha} (${model.isha.hour}:${model.isha.minute})');

      if (scheduleNotifications) {
        await _scheduleNotificationsIfNeeded(model);
      }

      return model;
    } catch (e) {
      debugPrint('خطأ في حساب مواقيت الصلاة: $e');
      return null;
    }
  }

  static Future<void> _scheduleNotificationsIfNeeded(
      PrayerTimesModel prayerTimes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prayerNotificationsEnabled =
          prefs.getBool('prayer_notifications') ?? true;

      if (!prayerNotificationsEnabled) {
        debugPrint('⚠️ إشعارات الصلاة معطلة');
        return;
      }

      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';
      final lastCalculated = prefs.getString(_lastCalculatedDateKey);

      if (lastCalculated != todayStr) {
        await NotificationService.schedulePrayerNotifications(prayerTimes);
        await prefs.setString(_lastCalculatedDateKey, todayStr);
        debugPrint('✅ تم جدولة إشعارات الصلاة ليوم جديد');
      } else {
        debugPrint('ℹ️ الإشعارات مجدولة بالفعل لهذا اليوم');
      }
    } catch (e) {
      debugPrint('خطأ في جدولة الإشعارات: $e');
    }
  }

  static double calculateQiblaDirection(double latitude, double longitude) {
    try {
      final coordinates = Coordinates(latitude, longitude);
      final qibla = Qibla.qibla(coordinates);
      debugPrint('✅ اتجاه القبلة: $qibla درجة');
      return qibla;
    } catch (e) {
      debugPrint('خطأ في حساب اتجاه القبلة: $e');
      return 0.0;
    }
  }

  static String getPrayerNameInArabic(String englishName) {
    String cleanName = englishName.toLowerCase().replaceAll('after', '');

    switch (cleanName) {
      case 'fajr':
        return 'الفجر';
      case 'sunrise':
        return 'الشروق';
      case 'dhuhr':
        return 'الظهر';
      case 'asr':
        return 'العصر';
      case 'maghrib':
        return 'المغرب';
      case 'isha':
        return 'العشاء';
      default:
        return englishName;
    }
  }

  static IconData getPrayerIconData(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight_outlined;
      case 'sunrise':
        return Icons.brightness_5;
      case 'dhuhr':
        return Icons.wb_sunny_outlined;
      case 'asr':
        return Icons.wb_sunny;
      case 'maghrib':
        return Icons.wb_twilight;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.mosque;
    }
  }

  static String getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return '🌅';
      case 'sunrise':
        return '☀️';
      case 'dhuhr':
        return '🌞';
      case 'asr':
        return '🌤️';
      case 'maghrib':
        return '🌇';
      case 'isha':
        return '🌙';
      default:
        return '🕌';
    }
  }
}
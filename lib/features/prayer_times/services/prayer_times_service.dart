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
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
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

        // Hierarchy: locality → subAdministrativeArea → administrativeArea → country
        String? cityName = _extractBestCityName(placemark);

        if (cityName != null && cityName.isNotEmpty) {
          cityName = cityName
              .replaceAll(' Governorate', '')
              .replaceAll('محافظة ', '')
              .replaceAll(' governorate', '')
              .trim();

          debugPrint('✅ اسم المدينة: $cityName');
          return cityName;
        }
      }

      // Fallback: جرب مرة تانية بـ locale مختلف
      return await _getCityNameFallback(latitude, longitude);
    } catch (e) {
      debugPrint('خطأ في الحصول على اسم المدينة: $e');
      return await _getCityNameFallback(latitude, longitude);
    }
  }

  static String? _extractBestCityName(Placemark placemark) {
    // جرب كل الحقول بالترتيب
    final candidates = [
      placemark.locality,
      placemark.subLocality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }

  static Future<String?> _getCityNameFallback(double lat, double lon) async {
    try {
      // انتظر شوية وجرب تاني
      await Future.delayed(const Duration(milliseconds: 500));

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        for (final placemark in placemarks) {
          final name = _extractBestCityName(placemark);
          if (name != null && name.isNotEmpty) {
            return name
                .replaceAll(' Governorate', '')
                .replaceAll('محافظة ', '')
                .trim();
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('فشل الـ fallback: $e');
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

// مدة صلاحية الموقع المحفوظ = 30 دقيقة
  static const int _locationCacheMinutes = 30;

  static Future<Map<String, dynamic>?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_latKey);
      final lon = prefs.getDouble(_lonKey);
      final city = prefs.getString(_cityKey);
      final lastCheck = prefs.getInt(_lastLocationCheckKey) ?? 0;

      if (lat != null && lon != null) {
        final lastCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheck);
        final minutesSinceLastCheck =
            DateTime.now().difference(lastCheckTime).inMinutes;

        debugPrint('⏱️ آخر تحقق من الموقع: منذ $minutesSinceLastCheck دقيقة');

        // لو فات أكتر من 30 دقيقة، مش موثوق
        final bool isFresh = minutesSinceLastCheck < _locationCacheMinutes;

        return {
          'latitude': lat,
          'longitude': lon,
          'city': city ?? 'موقعك الحالي',
          'isFresh': isFresh,
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
      final bool savedIsFresh = savedLocation?['isFresh'] == true;

      // لو الموقع المحفوظ حديث (أقل من 30 دقيقة)، استخدمه مباشرة
      if (savedIsFresh) {
        debugPrint('✅ الموقع المحفوظ حديث، لا حاجة للتحديث');
        return savedLocation;
      }

      debugPrint('🔄 الموقع قديم أو غير موجود، جاري التحقق من الموقع الحالي...');

      final currentPosition = await getCurrentLocation();

      if (currentPosition == null) {
        debugPrint('⚠️ لا يمكن الحصول على الموقع الحالي، استخدام المحفوظ');
        if (savedLocation != null) {
          // حدّث وقت الـ check حتى لو فشلنا
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_lastLocationCheckKey,
              DateTime.now().millisecondsSinceEpoch);
        }
        return savedLocation;
      }

      // لو في موقع محفوظ، قارن المسافة
      if (savedLocation != null) {
        final distance = Geolocator.distanceBetween(
          savedLocation['latitude'],
          savedLocation['longitude'],
          currentPosition.latitude,
          currentPosition.longitude,
        );

        final distanceKm = distance / 1000;
        debugPrint('📍 المسافة: ${distanceKm.toStringAsFixed(2)} كم');

        if (distanceKm <= _locationUpdateThresholdKm) {
          // نفس المنطقة تقريباً، حدّث الـ timestamp بس
          debugPrint('📍 نفس المنطقة، تحديث الوقت فقط');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_lastLocationCheckKey,
              DateTime.now().millisecondsSinceEpoch);

          // لو اسم المدينة فاضي، حاول تجيبه
          if (savedLocation['city'] == 'موقعك الحالي') {
            final cityName = await getCityName(
              currentPosition.latitude,
              currentPosition.longitude,
            );
            if (cityName != null && cityName.isNotEmpty) {
              await saveLocation(
                savedLocation['latitude'],
                savedLocation['longitude'],
                cityName,
              );
              return {...savedLocation, 'city': cityName};
            }
          }

          return savedLocation;
        }
      }

      // موقع جديد أو تغيّر بشكل كبير
      debugPrint('🔄 الموقع تغيّر، جاري التحديث...');
      final cityName = await getCityName(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      final finalCity = cityName ?? await _getAdminAreaName(
        currentPosition.latitude,
        currentPosition.longitude,
      ) ?? 'موقعك الحالي';

      await saveLocation(
        currentPosition.latitude,
        currentPosition.longitude,
        finalCity,
      );

      return {
        'latitude': currentPosition.latitude,
        'longitude': currentPosition.longitude,
        'city': finalCity,
      };
    } catch (e) {
      debugPrint('خطأ في checkAndUpdateLocation: $e');
      return await getSavedLocation();
    }
  }

// جلب اسم المحافظة كـ fallback أخير
  static Future<String?> _getAdminAreaName(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks.first.administrativeArea
            ?.replaceAll(' Governorate', '')
            .replaceAll('محافظة ', '')
            .trim();
      }
      return null;
    } catch (e) {
      return null;
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
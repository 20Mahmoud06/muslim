import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import '../../prayer_times/services/prayer_times_service.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit() : super(QiblaInitial());

  Future<void> checkQiblaStatus() async {
    emit(QiblaLoading());

    try {
      // فحص دعم الجهاز للحساسات
      final deviceSupport = await FlutterQiblah.androidDeviceSensorSupport();
      if (deviceSupport != null && !deviceSupport) {
        emit(const QiblaDeviceNotSupported());
        return;
      }

      // فحص حالة خدمة الموقع
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const QiblaLocationServiceDisabled());
        return;
      }

      // فحص صلاحيات الموقع
      LocationPermission permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.denied:
          emit(const QiblaPermissionDenied());
          return;

        case LocationPermission.deniedForever:
          emit(const QiblaPermissionDeniedForever());
          return;

        case LocationPermission.whileInUse:
        case LocationPermission.always:
        // تحميل معلومات الموقع
          await _loadLocationInfo();
          break;

        default:
          emit(const QiblaError(message: 'خطأ في التحقق من الصلاحيات'));
      }
    } catch (e) {
      emit(QiblaError(message: 'خطأ: ${e.toString()}'));
    }
  }

  Future<void> _loadLocationInfo() async {
    try {
      final location = await PrayerTimesService.checkAndUpdateLocation();
      final cityName = location?['city'] ?? 'موقعك الحالي';
      emit(QiblaReady(cityName: cityName));
    } catch (e) {
      emit(const QiblaReady(cityName: 'موقعك الحالي'));
    }
  }

  Future<void> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        emit(const QiblaPermissionDeniedForever());
      } else if (permission == LocationPermission.denied) {
        emit(const QiblaPermissionDenied());
      } else {
        // إعادة فحص الحالة
        await checkQiblaStatus();
      }
    } catch (e) {
      emit(QiblaError(message: 'خطأ في طلب الإذن: ${e.toString()}'));
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await Future.delayed(const Duration(milliseconds: 500));
    await checkQiblaStatus();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await Future.delayed(const Duration(seconds: 1));
    await checkQiblaStatus();
  }

  Future<void> retry() async {
    await checkQiblaStatus();
  }
}
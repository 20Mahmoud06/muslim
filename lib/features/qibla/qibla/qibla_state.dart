import 'package:equatable/equatable.dart';

abstract class QiblaState extends Equatable {
  const QiblaState();

  @override
  List<Object?> get props => [];
}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaReady extends QiblaState {
  final String cityName;

  const QiblaReady({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

class QiblaDeviceNotSupported extends QiblaState {
  final String message;

  const QiblaDeviceNotSupported({
    this.message = 'جهازك لا يحتوي على الحساسات المطلوبة لتحديد اتجاه القبلة',
  });

  @override
  List<Object?> get props => [message];
}

class QiblaLocationServiceDisabled extends QiblaState {
  final String message;

  const QiblaLocationServiceDisabled({
    this.message = 'يرجى تفعيل خدمة الموقع (GPS) من إعدادات الجهاز',
  });

  @override
  List<Object?> get props => [message];
}

class QiblaPermissionDenied extends QiblaState {
  final String message;

  const QiblaPermissionDenied({
    this.message = 'يرجى السماح بالوصول إلى الموقع لتحديد اتجاه القبلة',
  });

  @override
  List<Object?> get props => [message];
}

class QiblaPermissionDeniedForever extends QiblaState {
  final String message;

  const QiblaPermissionDeniedForever({
    this.message = 'يرجى تفعيل إذن الموقع من إعدادات التطبيق',
  });

  @override
  List<Object?> get props => [message];
}

class QiblaError extends QiblaState {
  final String message;

  const QiblaError({required this.message});

  @override
  List<Object?> get props => [message];
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../../../shared/custom_text.dart';
import '../../prayer_times/models/prayer_times_model.dart';
import '../../prayer_times/services/prayer_times_service.dart';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  PrayerTimesModel? _prayerTimes;
  String _cityName = 'جاري التحميل...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final savedLocation = await PrayerTimesService.getSavedLocation();

      double? lat;
      double? lon;
      String? city;

      if (savedLocation != null) {
        lat = savedLocation['latitude'];
        lon = savedLocation['longitude'];
        city = savedLocation['city'];
      } else {
        final position = await PrayerTimesService.getCurrentLocation();
        if (position != null) {
          lat = position.latitude;
          lon = position.longitude;
          city = await PrayerTimesService.getCityName(lat, lon);
          await PrayerTimesService.saveLocation(
              lat, lon, city ?? 'موقعك الحالي');
        }
      }

      if (lat != null && lon != null) {
        final prayerTimes = await PrayerTimesService.calculatePrayerTimes(
          latitude: lat,
          longitude: lon,
        );

        setState(() {
          _prayerTimes = prayerTimes;
          _cityName = city ?? 'موقعك الحالي';
          _isLoading = false;
        });
      } else {
        setState(() {
          _cityName = 'موقعك الحالي';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _cityName = 'موقعك الحالي';
        _isLoading = false;
      });
      print('خطأ في تحميل المواقيت: $e');
    }
  }

  String _to12Hour(DateTime time) {
    final format = DateFormat('hh:mm', 'ar');
    final period = DateFormat('a', 'ar').format(time);
    return '${format.format(time)} $period';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, RouteNames.prayerTimesDetail),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: EdgeInsets.all(20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    if (_prayerTimes == null) {
      return const SizedBox.shrink();
    }

    // الترتيب من اليمين للشمال
    final List<String> prayers = [
      'العشاء',
      'المغرب',
      'العصر',
      'الظهر',
      'الشروق',
      'الفجر',
    ];

    final List<DateTime> times = [
      _prayerTimes!.isha,
      _prayerTimes!.maghrib,
      _prayerTimes!.asr,
      _prayerTimes!.dhuhr,
      _prayerTimes!.sunrise,
      _prayerTimes!.fajr,
    ];

    final List<IconData> icons = [
      Icons.nightlight_round,
      Icons.wb_twilight,
      Icons.wb_sunny,
      Icons.wb_sunny_outlined,
      Icons.brightness_5,
      Icons.wb_twilight_outlined,
    ];

    // المفاتيح بالإنجليزي لمقارنتها مع currentPrayer و nextPrayer
    final List<String> keys = [
      'isha',
      'maghrib',
      'asr',
      'dhuhr',
      'sunrise',
      'fajr',
    ];

    // ⭐ الصلاة القادمة (NextPrayer)
    String nextPrayerKey = _prayerTimes!.nextPrayer.toLowerCase();

    // تحويل الأسماء الإنجليزية للمكتبة للأسماء المتوقعة
    if (nextPrayerKey == 'fajrafter') nextPrayerKey = 'fajr';
    if (nextPrayerKey == 'dhuhrafter') nextPrayerKey = 'dhuhr';
    if (nextPrayerKey == 'asrafter') nextPrayerKey = 'asr';
    if (nextPrayerKey == 'maghribafter') nextPrayerKey = 'maghrib';
    if (nextPrayerKey == 'ishaafter') nextPrayerKey = 'isha';

    // إيجاد الـ index
    final int nextIndex = keys.indexOf(nextPrayerKey);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteNames.prayerTimesDetail),
      child: Column(
        children: [
          // اسم المحافظة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              CustomText(
                text: _cityName,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.primaryColor,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ودجت المواقيت
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 2.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أسماء الصلوات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: prayers.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final name = entry.value;
                      final bool isNext = idx == nextIndex;
                      return Expanded(
                        child: CustomText(
                          text: name,
                          textAlign: TextAlign.center,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          textColor: isNext ? AppColors.secondaryColor : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),

                  // الأيقونات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: icons.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final icon = entry.value;
                      final bool isNext = idx == nextIndex;
                      return Expanded(
                        child: Icon(
                          icon,
                          size: 26.sp,
                          color: isNext ? AppColors.secondaryColor : Colors.grey.shade700,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),

                  // الأوقات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: times.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final time = entry.value;
                      final bool isNext = idx == nextIndex;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          decoration: isNext
                              ? BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          )
                              : null,
                          child: CustomText(
                            text: _to12Hour(time),
                            textAlign: TextAlign.center,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            textColor: isNext ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
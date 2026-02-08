import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri_date/hijri_date.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../../prayer_times/models/prayer_times_model.dart';
import '../../prayer_times/services/prayer_times_service.dart';
import 'home_pattern_painter.dart';

class Heading extends StatefulWidget {
  const Heading({super.key});

  @override
  State<Heading> createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  PrayerTimesModel? _prayerTimes;
  String _cityName = 'جاري التحميل...';
  String _countdown = '٠٠:٠٠:٠٠';
  Timer? _countdownTimer;
  final HijriDate _hijriDate = HijriDate.now();

  String _toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  // ⭐ تحويل اسم الصلاة من الإنجليزي للعربي مع معالجة "After"
  String _getNextPrayerNameInArabic() {
    if (_prayerTimes == null) return '...';

    String prayerName = _prayerTimes!.nextPrayer.toLowerCase();

    // إزالة "after" من اسم الصلاة
    prayerName = prayerName.replaceAll('after', '');

    // تحويل للعربي
    switch (prayerName) {
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
        return prayerName; // في حالة اسم غير متوقع
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      // ⭐ استخدام checkAndUpdateLocation بدلاً من getSavedLocation
      final location = await PrayerTimesService.checkAndUpdateLocation();

      if (location != null) {
        final prayerTimes = await PrayerTimesService.calculatePrayerTimes(
          latitude: location['latitude'],
          longitude: location['longitude'],
        );

        if (mounted) {
          setState(() {
            _prayerTimes = prayerTimes;
            _cityName = location['city'] ?? 'موقعك الحالي';
          });
        }
      }
    } catch (e) {
      print('خطأ في تحميل المواقيت: $e');
      if (mounted) {
        setState(() => _cityName = 'غير محدد');
      }
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prayerTimes?.nextPrayerTime != null) {
        final now = DateTime.now();
        final nextPrayer = _prayerTimes!.nextPrayerTime!;
        final difference = nextPrayer.difference(now);

        if (difference.isNegative) {
          _loadPrayerTimes();
        } else {
          final hours = difference.inHours.toString().padLeft(2, '0');
          final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

          if (mounted) {
            setState(() {
              // تحويل للأرقام العربية
              _countdown = _toArabicNumbers('$hours:$minutes:$seconds');
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.sizeOf(context).height / 3.h;

    return SizedBox(
      width: double.infinity,
      height: headerHeight,
      child: Stack(
        children: [
          // الخلفية الخضراء
          Container(
            width: double.infinity,
            height: headerHeight,
            color: AppColors.primaryColor,
          ),

          // الزخرفة الإسلامية
          Positioned.fill(
            child: CustomPaint(
              painter: HomePatternPainter(),
            ),
          ),

          // المحتوى الأساسي
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // التاريخ الهجري - قابل للضغط
                        GestureDetector(
                          onTap: () {
                            // التنقل لصفحة التاريخ الهجري
                            Navigator.pushNamed(context, '/hijri_calendar');
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              CustomText(
                                text:
                                '${_toArabicNumbers(_hijriDate.hDay.toString())} ${_getHijriMonthName(_hijriDate.hMonth)} ${_toArabicNumbers(_hijriDate.hYear.toString())}هـ',
                                textColor: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // الصلاة القادمة - محدثة ⭐
                        Row(
                          children: [
                            SizedBox(width: 5.w),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'الصلاة القادمة: ',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontFamily: 'cairo',
                                    ),
                                  ),
                                  TextSpan(
                                    text: _getNextPrayerNameInArabic(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      fontFamily: 'cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                    Image.asset(
                      'assets/logo/quran-small.png',
                      width: 70.w,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // العد التنازلي بالأرقام العربية
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5.w),
                    CustomText(
                      text: _countdown,
                      textColor: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // الموقع (اسم المحافظة)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 5.w),
                    CustomText(
                      text: _cityName,
                      textColor: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getHijriMonthName(int month) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[month - 1];
  }
}
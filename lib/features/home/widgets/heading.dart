import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../../prayer_times/models/prayer_times_model.dart';
import '../../prayer_times/services/prayer_times_service.dart';
import '../../hijri_calendar/model/hijri_date_result.dart';
import '../../hijri_calendar/services/hijri_date_service.dart';
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
  HijriDateResult? _hijriDate;

  @override
  void initState() {
    super.initState();
    // ✅ نسمع على الـ notifier أولاً قبل أي حاجة
    HijriDateService.adjustmentNotifier.addListener(_onAdjustmentChanged);
    _loadPrayerTimes();
    _startCountdownTimer();
    // ✅ نحمل التاريخ بعد أول frame عشان نضمن إن الـ repository خلص تحميله
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHijriDate());
  }

  void _onAdjustmentChanged() => _loadHijriDate();

  @override
  void dispose() {
    _countdownTimer?.cancel();
    HijriDateService.adjustmentNotifier.removeListener(_onAdjustmentChanged);
    super.dispose();
  }

  Future<void> _loadHijriDate() async {
    final date = await HijriDateService.getCurrentHijriDate();
    if (mounted) setState(() => _hijriDate = date);
  }

  String _getNextPrayerNameInArabic() {
    if (_prayerTimes == null) return '...';
    String prayerName =
    _prayerTimes!.nextPrayer.toLowerCase().replaceAll('after', '');
    switch (prayerName) {
      case 'fajr':    return 'الفجر';
      case 'sunrise': return 'الشروق';
      case 'dhuhr':   return 'الظهر';
      case 'asr':     return 'العصر';
      case 'maghrib': return 'المغرب';
      case 'isha':    return 'العشاء';
      default:        return prayerName;
    }
  }

  Future<void> _loadPrayerTimes() async {
    try {
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
    } catch (_) {
      if (mounted) setState(() => _cityName = 'غير محدد');
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prayerTimes?.nextPrayerTime != null) {
        final difference = _prayerTimes!.nextPrayerTime!.difference(DateTime.now());
        if (difference.isNegative) {
          _loadPrayerTimes();
        } else {
          final h = difference.inHours.toString().padLeft(2, '0');
          final m = (difference.inMinutes % 60).toString().padLeft(2, '0');
          final s = (difference.inSeconds % 60).toString().padLeft(2, '0');
          if (mounted) {
            setState(() {
              _countdown = HijriDateService.toArabicNumbers('$h:$m:$s');
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
          Container(width: double.infinity, height: headerHeight,
              color: AppColors.primaryColor),
          Positioned.fill(child: CustomPaint(painter: HomePatternPainter())),
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
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/hijri_calendar');
                            HijriDateService.clearCache();
                            _loadHijriDate();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,
                                  color: Colors.white, size: 20.sp),
                              SizedBox(width: 5.w),
                              _hijriDate != null
                                  ? CustomText(
                                text: HijriDateService.toArabicNumbers(
                                  '${_hijriDate!.hDay} '
                                      '${HijriDateService.getArabicMonthName(_hijriDate!.hMonth)} '
                                      '${_hijriDate!.hYear}هـ',
                                ),
                                textColor: Colors.white,
                                fontSize: 15.sp,
                              )
                                  : CustomText(
                                text: 'جاري التحميل...',
                                textColor: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            SizedBox(width: 5.w),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'الصلاة القادمة: ',
                                    style: TextStyle(fontSize: 15.sp,
                                        color: Colors.white, fontFamily: 'cairo'),
                                  ),
                                  TextSpan(
                                    text: _getNextPrayerNameInArabic(),
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp, fontFamily: 'cairo'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                    Image.asset('assets/logo/quran-small.png', width: 70.w),
                  ],
                ),
                SizedBox(height: 10.h),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 20.sp),
                    SizedBox(width: 5.w),
                    CustomText(text: _cityName,
                        textColor: Colors.white, fontSize: 15.sp),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
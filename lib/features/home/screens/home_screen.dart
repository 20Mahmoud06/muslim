import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/home/widgets/features_section.dart';
import 'package:muslim/features/home/widgets/heading.dart';
import 'package:muslim/features/home/widgets/prayer_times.dart';
import 'package:muslim/features/home/widgets/daily_hadith_section.dart';
import '../widgets/azkar_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.sizeOf(context).height / 3.h;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Heading(),
                    Positioned(
                      top: headerHeight - 55.h,
                      left: 16.w,
                      right: 16.w,
                      child: const PrayerTimesWidget(),
                    ),
                  ],
                ),

                SizedBox(height: 100.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const FeaturesSection(),
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const AzkarSection(),
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const DailyHadithSection(),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
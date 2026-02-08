import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/onboarding/widgets/location_screen.dart';
import 'package:muslim/features/onboarding/widgets/notification_screen.dart';
import 'package:muslim/features/onboarding/widgets/welcome_screen.dart';
import '../widgets/page_indicator_dot.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() => _currentPage = page);
                  },
                  children: [
                    WelcomeScreen(pageController: _pageController),
                    NotificationScreen(pageController: _pageController),
                    LocationScreen(pageController: _pageController),
                  ],
                ),
              ),
            ),

            // Page indicator
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: PageIndicatorDot(
                        isActive: _currentPage == index,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
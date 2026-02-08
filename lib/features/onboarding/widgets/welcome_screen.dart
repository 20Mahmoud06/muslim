import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/onboarding/widgets/custom_onboarding.dart';

class WelcomeScreen extends StatelessWidget {
  final PageController pageController;

  const WelcomeScreen({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomOnboarding(
      imageWidget: Image.asset(
        'assets/logo/quran.png',
        height: 160.h,
      ),
      topPadding: 40,
      imageHeight: 200,
      titleTopPadding: 30,
      descriptionTopPadding: 20,
      buttonTopPadding: 59,
      title: 'مسلم',
      description:
      'تطبيق يساعدك على تذكّر أوقات الصلاة، قراءة القرآن، والأذكار اليومية بسهولة.',
      buttonText: 'التالي',
      onButtonPressed: () async {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      showNextButton: true,
    );
  }
}
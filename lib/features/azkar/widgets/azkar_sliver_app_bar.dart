import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/azkar/widgets/azkar_pattern_painter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

/// SliverAppBar قابل للطي لصفحة الأذكار مع Animation للحديث
class AzkarSliverAppBar extends StatefulWidget {
  const AzkarSliverAppBar({super.key});

  @override
  State<AzkarSliverAppBar> createState() => _AzkarSliverAppBarState();
}

class _AzkarSliverAppBarState extends State<AzkarSliverAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _hadithAnimationController;
  late Animation<double> _hadithFadeAnimation;
  late Animation<Offset> _hadithSlideAnimation;
  late Animation<double> _hadithScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Animation للحديث (منقول من صفحة أسماء الله)
    _hadithAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _hadithFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _hadithAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _hadithSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _hadithAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _hadithScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _hadithAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // بدء الـ Animation
    _hadithAnimationController.forward();
  }

  @override
  void dispose() {
    _hadithAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240.h,
      floating: false,
      pinned: true,
      elevation: 0,
      leading: _buildBackButton(context),
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: _buildFlexibleSpace(),
    );
  }

  /// زر الرجوع
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  /// بناء المساحة المرنة
  Widget _buildFlexibleSpace() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollRatio = _calculateScrollRatio(constraints);

        return FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(bottom: 16.h),
          title: _buildTitle(scrollRatio),
          background: _buildBackground(),
        );
      },
    );
  }

  /// حساب نسبة التمرير
  double _calculateScrollRatio(BoxConstraints constraints) {
    return 1.0 -
        ((constraints.maxHeight - kToolbarHeight) / (240.h - kToolbarHeight))
            .clamp(0.0, 1.0);
  }

  /// بناء العنوان
  Widget _buildTitle(double scrollRatio) {
    return Opacity(
      opacity: scrollRatio < 0.3 ? 0.0 : (scrollRatio - 0.3) / 0.7,
      child: CustomText(
        text: 'حصن المسلم',
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        textColor: Colors.white,
      ),
    );
  }

  /// بناء الخلفية
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor,
            AppColors.secondaryColor,
            AppColors.thirdColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          // الخلفية الزخرفية
          Positioned.fill(
            child: CustomPaint(
              painter: AzkarPatternPainter(),
            ),
          ),
          // المحتوى
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    _buildIcon(),
                    SizedBox(height: 20.h),
                    _buildAnimatedQuoteBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// أيقونة الكتاب
  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 48.sp,
        color: Colors.white,
      ),
    );
  }

  /// صندوق الاقتباس مع Animation (منقول من صفحة أسماء الله)
  Widget _buildAnimatedQuoteBox() {
    return FadeTransition(
      opacity: _hadithFadeAnimation,
      child: SlideTransition(
        position: _hadithSlideAnimation,
        child: ScaleTransition(
          scale: _hadithScaleAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 16.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // أيقونة علامة الاقتباس
                Icon(
                  Icons.format_quote_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: 24.sp,
                ),
                SizedBox(height: 10.h),
                // نص الحديث
                CustomText(
                  text: 'من أذكار الكتاب والسنة',
                  textAlign: TextAlign.center,
                  fontSize: 16.sp,
                  textColor: Colors.white,
                  height: 1.8,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                // خط فاصل زخرفي
                Container(
                  height: 2.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
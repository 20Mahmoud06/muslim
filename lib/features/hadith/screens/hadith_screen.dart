import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/hadith_model.dart';
import '../services/hadith_service.dart';
import '../widgets/hadith_card.dart';
import '../widgets/hadith_pattern_painter.dart';
import 'hadith_detail_screen.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen>
    with TickerProviderStateMixin {
  List<HadithModel> _hadiths = [];
  bool _isLoading = true;

  late AnimationController _gridAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadHadiths();
  }

  void _initializeAnimations() {
    // Animation للـ Grid
    _gridAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animation للـ Header
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _headerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // بدء الـ Animations
    _gridAnimationController.forward();
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    setState(() => _isLoading = true);

    final hadiths = await HadithService.loadHadiths();

    setState(() {
      _hadiths = hadiths;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar مخصص
          _buildSliverAppBar(),

          // Grid الأحاديث
          _isLoading
              ? SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          )
              : _buildGridView(),
        ],
      ),
    );
  }

  // AppBar متحرك
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 240.h,
      floating: false,
      pinned: true,
      elevation: 0,
      leading: IconButton(
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
      ),
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final scrollRatio = 1.0 -
              ((constraints.maxHeight - kToolbarHeight) /
                  (240.h - kToolbarHeight))
                  .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: EdgeInsets.only(bottom: 16.h),
            title: Opacity(
              opacity: scrollRatio < 0.3
                  ? 0.0
                  : (scrollRatio - 0.3) / 0.7,
              child: CustomText(
                text: 'الأربعون النووية',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
            background: Container(
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
                  // زخرفة خلفية إسلامية
                  Positioned.fill(
                    child: CustomPaint(
                      painter: HadithPatternPainter(),
                    ),
                  ),
                  // المحتوى
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h),
                          // أيقونة مع ظل وتأثير متوهج
                          Container(
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
                              Icons.auto_stories_rounded,
                              size: 48.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),

                          // معلومات الكتاب مع Animation
                          FadeTransition(
                            opacity: _headerFadeAnimation,
                            child: SlideTransition(
                              position: _headerSlideAnimation,
                              child: ScaleTransition(
                                scale: _headerScaleAnimation,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 2.h,
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
                                      SizedBox(height: 5.h),
                                      // نص وصف المجموعة
                                      CustomText(
                                        text: 'مجموعة من أصح الأحاديث النبوية\nجمعها الإمام النووي',
                                        textAlign: TextAlign.center,
                                        fontSize: 16.sp,
                                        textColor: Colors.white,
                                        height: 1.8,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 5.h),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // عرض الشبكة مع Animation
  Widget _buildGridView() {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final hadith = _hadiths[index];

            // Animation للـ Grid (نفس اللي في صفحة أسماء الله)
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: _gridAnimationController,
                curve: Interval(
                  (index * 0.05).clamp(0.0, 0.5),
                  1.0,
                  curve: Curves.easeOut,
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _gridAnimationController,
                    curve: Interval(
                      (index * 0.05).clamp(0.0, 0.5),
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _gridAnimationController,
                      curve: Interval(
                        (index * 0.05).clamp(0.0, 0.5),
                        1.0,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                  ),
                  child: HadithCard(
                    hadith: hadith,
                    onTap: () => _openHadithDetail(hadith),
                  ),
                ),
              ),
            );
          },
          childCount: _hadiths.length,
        ),
      ),
    );
  }

  // فتح صفحة التفاصيل
  void _openHadithDetail(HadithModel hadith) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HadithDetailScreen(
          hadith: hadith,
          allHadiths: _hadiths,
        ),
      ),
    );
  }
}
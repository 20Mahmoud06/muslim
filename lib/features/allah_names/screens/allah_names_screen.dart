import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/allah_names_cubit.dart';
import '../widgets/allah_names_pattern_painter.dart';
import '../widgets/allah_name_card.dart';
import '../widgets/name_detail_overlay.dart';

class AllahNamesScreen extends StatefulWidget {
  const AllahNamesScreen({super.key});

  @override
  State<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends State<AllahNamesScreen>
    with TickerProviderStateMixin {
  late AnimationController _gridAnimationController;
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
    // Animation للـ Grid (منقول من صفحة الأذكار)
    _gridAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animation للحديث
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

    // بدء الـ Animations
    _gridAnimationController.forward();
    _hadithAnimationController.forward();
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    _hadithAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllahNamesCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<AllahNamesCubit, AllahNamesState>(
          builder: (context, state) {
            return Stack(
              children: [
                // الصفحة الرئيسية
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // AppBar محسّن
                    SliverAppBar(
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
                                text: 'أسماء ٱللَّٰهِ الحسنى',
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
                                  // خلفية زخرفية إسلامية محسّنة
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.06,
                                      child: CustomPaint(
                                        painter: AllahNamesPatternPainter(),
                                      ),
                                    ),
                                  ),
                                  // المحتوى
                                  SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 60.w,
                                      ),
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
                                              Icons.mosque_rounded,
                                              size: 48.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 15.h),

                                          // الحديث الشريف مع Animation
                                          FadeTransition(
                                            opacity: _hadithFadeAnimation,
                                            child: SlideTransition(
                                              position: _hadithSlideAnimation,
                                              child: ScaleTransition(
                                                scale: _hadithScaleAnimation,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 24.w,
                                                    vertical: 8.h,
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
                                                      // نص الحديث
                                                      CustomText(
                                                        text: 'إن للَّٰهِ تسعة وتسعين اسماً\nمن أحصاها دخل الجنة',
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
                    ),

                    // عداد الأسماء المحسّن
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondaryColor.withOpacity(0.15),
                              AppColors.primaryColor.withOpacity(0.1),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.grid_view_rounded,
                                color: AppColors.primaryColor,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            CustomText(
                              text: 'مجموعة الأسماء الحسنى',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              textColor: AppColors.primaryColor,
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.secondaryColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CustomText(
                                text: '99',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Grid of Names مع Animation من صفحة الأذكار
                    if (state is AllahNamesLoaded || state is AllahNameSelected)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
                        sliver: SliverGrid(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _getCrossAxisCount(context),
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final cubit = context.read<AllahNamesCubit>();
                              final name = cubit.allNames[index];
                              final isSelected = state is AllahNameSelected &&
                                  state.selectedName.id == name.id;

                              // Animation للـ Grid (منقول من صفحة الأذكار)
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
                                    child: AllahNameCard(
                                      name: name,
                                      isSelected: isSelected,
                                      onTap: () {
                                        cubit.selectName(name);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: context
                                .read<AllahNamesCubit>()
                                .allNames
                                .length,
                          ),
                        ),
                      ),
                  ],
                ),

                // Overlay للتفاصيل مع Animation
                if (state is AllahNameSelected)
                  NameDetailOverlay(
                    name: state.selectedName,
                    onClose: () {
                      context.read<AllahNamesCubit>().clearSelection();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    return 3;
  }
}
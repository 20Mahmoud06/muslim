import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../models/azkar_model.dart';
import '../widgets/zikr_card.dart';
import '../widgets/zikr_counter.dart';
import '../widgets/progress_bar.dart';
import '../widgets/navigation_buttons.dart';

class AzkarDetailScreen extends StatefulWidget {
  final String categoryTitle;
  final Map<String, dynamic> categoryData;
  final List<Color> categoryGradient;
  final IconData categoryIcon;

  const AzkarDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryData,
    required this.categoryGradient,
    required this.categoryIcon,
  });

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen>
    with SingleTickerProviderStateMixin {
  late AzkarCategory azkarCategory;
  late AnimationController _animationController;
  int currentZikrIndex = 0;
  bool showFootnote = false;

  @override
  void initState() {
    super.initState();
    azkarCategory = AzkarCategory.fromJson(
      widget.categoryTitle,
      widget.categoryData,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextZikr() {
    if (currentZikrIndex < azkarCategory.azkar.length - 1) {
      setState(() {
        currentZikrIndex++;
        showFootnote = false;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  void _previousZikr() {
    if (currentZikrIndex > 0) {
      setState(() {
        currentZikrIndex--;
        showFootnote = false;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  void _incrementCount() {
    setState(() {
      azkarCategory.azkar[currentZikrIndex].increment();
      if (azkarCategory.azkar[currentZikrIndex].isCompleted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && currentZikrIndex < azkarCategory.azkar.length - 1) {
            _nextZikr();
          }
        });
      }
    });
  }

  void _resetAll() {
    setState(() {
      for (var zikr in azkarCategory.azkar) {
        zikr.reset();
      }
      currentZikrIndex = 0;
      showFootnote = false;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentZikr = azkarCategory.azkar[currentZikrIndex];
    final progress = (currentZikrIndex + 1) / azkarCategory.azkar.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom App Bar with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.categoryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.categoryTitle,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.white, size: 22.sp),
                          onPressed: _resetAll,
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar
                  AzkarProgressBar(
                    progress: progress,
                    gradient: widget.categoryGradient,
                  ),

                  // Counter & Progress Text
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.categoryIcon, color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          '${currentZikrIndex + 1} من ${azkarCategory.azkar.length}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: FadeTransition(
              opacity: _animationController,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),

                        // Zikr Card
                        ZikrCard(
                          zikr: currentZikr,
                          gradient: widget.categoryGradient,
                          showFootnote: showFootnote,
                          onToggleFootnote: () {
                            setState(() {
                              showFootnote = !showFootnote;
                            });
                          },
                        ),

                        SizedBox(height: 24.h),

                        // Counter Circle
                        if (currentZikr.count > 1)
                          ZikrCounter(
                            zikr: currentZikr,
                            gradient: widget.categoryGradient,
                            onTap: _incrementCount,
                          ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Navigation Buttons
          NavigationButtons(
            canGoPrevious: currentZikrIndex > 0,
            canGoNext: currentZikrIndex < azkarCategory.azkar.length - 1,
            onPrevious: _previousZikr,
            onNext: _nextZikr,
            gradient: widget.categoryGradient,
          ),
        ],
      ),
    );
  }
}
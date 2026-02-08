import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/custom_text.dart';

class AzkarCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final int index;
  final AnimationController animationController;
  final VoidCallback onTap;

  const AzkarCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.index,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animationController,
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
            parent: animationController,
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
              parent: animationController,
              curve: Interval(
                (index * 0.05).clamp(0.0, 0.5),
                1.0,
                curve: Curves.easeOutBack,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon Container
                      Container(
                        width: 54.w,
                        height: 54.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Title
                      Flexible(
                        child: CustomText(
                          text: title,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Arrow Icon
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.7),
                        size: 12.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
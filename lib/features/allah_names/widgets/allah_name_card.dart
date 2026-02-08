import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/allah_names_model.dart';

class AllahNameCard extends StatefulWidget {
  final AsmaaAllahModel name;
  final VoidCallback onTap;
  final bool isSelected;

  const AllahNameCard({
    super.key,
    required this.name,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<AllahNameCard> createState() => _AllahNameCardState();
}

class _AllahNameCardState extends State<AllahNameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 100), widget.onTap);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isSelected
                  ? [AppColors.thirdColor, AppColors.secondaryColor]
                  : [
                AppColors.secondaryColor.withOpacity(0.9),
                AppColors.primaryColor
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppColors.thirdColor.withOpacity(0.4)
                    : AppColors.primaryColor.withOpacity(0.25),
                blurRadius: widget.isSelected ? 12 : 8,
                offset: Offset(0, widget.isSelected ? 6 : 4),
                spreadRadius: widget.isSelected ? 1 : 0,
              ),
            ],
            border: widget.isSelected
                ? Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // العدد مع تأثير أفضل
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: CustomText(
                  text: '${widget.name.id}',
                  fontSize: 13.sp,
                  textColor: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 14.h),
              // الاسم
              Flexible(
                child: CustomText(
                  text: widget.name.name,
                  textAlign: TextAlign.center,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                  height: 1.4,
                ),
              ),
              // مؤشر صغير للتحديد
              if (widget.isSelected) ...[
                SizedBox(height: 8.h),
                Container(
                  width: 30.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
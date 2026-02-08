import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

/// زر "أذكار أخرى"
class OtherAzkarButton extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onTap;

  const OtherAzkarButton({
    super.key,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: _buildButton(),
        ),
      ),
    );
  }

  /// بناء الزر
  Widget _buildButton() {
    return Container(
      decoration: _buildDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  /// زخرفة الزر
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.secondaryColor,
          AppColors.thirdColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// محتوى الزر
  Widget _buildContent() {
    return Row(
      children: [
        _buildIcon(),
        SizedBox(width: 16.w),
        Expanded(child: _buildTexts()),
        _buildArrow(),
      ],
    );
  }

  /// أيقونة الزر
  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.more_horiz,
        color: Colors.white,
        size: 28.sp,
      ),
    );
  }

  /// النصوص
  Widget _buildTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'أذكار أخرى',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          textColor: Colors.white,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: 'المزيد من الأذكار والأدعية',
          fontSize: 13.sp,
          textColor: Colors.white.withOpacity(0.9),
        ),
      ],
    );
  }

  /// سهم التوجيه
  Widget _buildArrow() {
    return Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
      size: 20.sp,
    );
  }
}
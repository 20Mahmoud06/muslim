import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../models/azkar_model.dart';

class ZikrCard extends StatelessWidget {
  final Zikr zikr;
  final List<Color> gradient;
  final bool showFootnote;
  final VoidCallback onToggleFootnote;

  const ZikrCard({
    super.key,
    required this.zikr,
    required this.gradient,
    required this.showFootnote,
    required this.onToggleFootnote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Zikr Text
          CustomText(
            text: zikr.text,
            fontSize: 20.sp,
            textColor: AppColors.primaryColor,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
            height: 2,
          ),

          // Footnote Button
          if (zikr.footnote.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: showFootnote
                      ? gradient
                      : [gradient[0].withOpacity(0.1), gradient[1].withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: onToggleFootnote,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          showFootnote ? Icons.keyboard_arrow_up : Icons.info_outline,
                          color: showFootnote ? Colors.white : gradient[0],
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: showFootnote ? 'إخفاء البيان' : 'إظهار البيان',
                          textColor: showFootnote ? Colors.white : gradient[0],
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Footnote Text with Animation
          if (showFootnote && zikr.footnote.isNotEmpty)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient[0].withOpacity(0.1),
                    gradient[1].withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: gradient[0].withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: gradient[0],
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'البيان',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        textColor: gradient[0],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: zikr.footnote,
                    fontSize: 14.sp,
                    textColor: AppColors.grey,
                    textAlign: TextAlign.center,
                    height: 1.8,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
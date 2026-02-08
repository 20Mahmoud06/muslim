import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/hadith/widgets/card_pattern_painter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/hadith_model.dart';

class HadithCard extends StatelessWidget {
  final HadithModel hadith;
  final VoidCallback? onTap;

  const HadithCard({
    super.key,
    required this.hadith,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // زخرفة خلفية
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CustomPaint(
                    painter: CardPatternPainter(),
                  ),
                ),
              ),
            ),

            // المحتوى
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w).copyWith(top: 16.h, bottom: 16.h), // عدلت هنا ليكون متماثل وأضفت bottom
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // لتركيز العناصر عمودياً
                crossAxisAlignment: CrossAxisAlignment.center, // لتركيز أفقي
                children: [
                  // رقم الحديث (دائرة بحجم ثابت)
                  Container(
                    width: 60.w, // حجم ثابت للدائرة (غير حسب احتياجك، مثلاً 90.w لو أرقام أكبر)
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        text: '${hadith.idInBook}',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        textColor: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h), // زيادة شوية لتوازن

                  // رقم الحديث بالعربي
                  CustomText(
                    text: 'الحديث ${hadith.numberInArabic}',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10.h), // زيادة لتوازن أفضل

                  // زر القراءة
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w, // زيادة شوية للزر عشان يبقى أوسع إذا لزم
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'اقرأ الحديث',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
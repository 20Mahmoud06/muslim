import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/azkar_category_card.dart';

/// شبكة عرض فئات الأذكار
class AzkarGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final AnimationController animationController;
  final Function(String title, List<Color> gradient, IconData icon) onCategoryTap;

  const AzkarGrid({
    super.key,
    required this.categories,
    required this.animationController,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.88,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final category = categories[index];
            return AzkarCategoryCard(
              title: category['title'],
              icon: category['icon'],
              gradient: category['gradient'],
              index: index,
              animationController: animationController,
              onTap: () => onCategoryTap(
                category['title'],
                category['gradient'],
                category['icon'],
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}
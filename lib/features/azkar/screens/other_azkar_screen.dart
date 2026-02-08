import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import 'azkar_detail_screen.dart';

class OtherAzkarScreen extends StatefulWidget {
  final Map<String, dynamic> azkarData;

  const OtherAzkarScreen({
    super.key,
    required this.azkarData,
  });

  @override
  State<OtherAzkarScreen> createState() => _OtherAzkarScreenState();
}

class _OtherAzkarScreenState extends State<OtherAzkarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<String> categoryKeys;

  @override
  void initState() {
    super.initState();
    categoryKeys = widget.azkarData.keys.toList();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'أذكار أخرى',
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          textColor: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, color: AppColors.primaryColor, size: 20.sp),
                SizedBox(width: 8.w),
                CustomText(
                  text: '${categoryKeys.length} تصنيف',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: categoryKeys.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categoryKeys[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String categoryTitle, int index) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (index * 0.05).clamp(0.0, 0.5),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index * 0.05).clamp(0.0, 0.5),
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AzkarDetailScreen(
                      categoryTitle: categoryTitle,
                      categoryData: widget.azkarData[categoryTitle],
                      categoryGradient: [AppColors.secondaryColor, AppColors.thirdColor],
                      categoryIcon: Icons.menu_book,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondaryColor, AppColors.thirdColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomText(
                        text: categoryTitle,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.grey,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
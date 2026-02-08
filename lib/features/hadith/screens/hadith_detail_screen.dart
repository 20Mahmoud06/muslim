import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/hadith_model.dart';
import '../widgets/font_control_bar.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/hadith_content_widget.dart';
import '../data/hadith_names.dart';

class HadithDetailScreen extends StatefulWidget {
  final HadithModel hadith;
  final List<HadithModel> allHadiths;

  const HadithDetailScreen({
    super.key,
    required this.hadith,
    required this.allHadiths,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double _fontSize = 17.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.allHadiths.indexWhere((h) => h.id == widget.hadith.id);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getHadithName(int index) {
    return index >= 0 && index < HadithNames.names.length
        ? HadithNames.names[index]
        : 'الحديث ${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // شريط التحكم بالخط
          FontControlBar(
            fontSize: _fontSize,
            onIncrease: () {
              if (_fontSize < 28) {
                setState(() => _fontSize++);
              }
            },
            onDecrease: () {
              if (_fontSize > 12) {
                setState(() => _fontSize--);
              }
            },
          ),

          // المحتوى
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemCount: widget.allHadiths.length,
              itemBuilder: (context, index) {
                return HadithContentWidget(
                  hadith: widget.allHadiths[index],
                  hadithName: _getHadithName(index),
                  fontSize: _fontSize,
                );
              },
            ),
          ),

          // أزرار التنقل
          NavigationButtons(
            currentIndex: _currentIndex,
            totalCount: widget.allHadiths.length,
            onPrevious: _currentIndex > 0
                ? () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
            onNext: _currentIndex < widget.allHadiths.length - 1
                ? () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
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
      centerTitle: true,
      title: CustomText(
        text: _getHadithName(_currentIndex),
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        textColor: Colors.white,
      ),
      actions: [
        // زر النسخ
        IconButton(
          icon: Icon(Icons.copy_outlined, color: Colors.white, size: 24.sp),
          onPressed: _copyHadith,
        ),
      ],
    );
  }

  // نسخ الحديث - تم إزالة تكرار المصدر
  void _copyHadith() {
    final hadith = widget.allHadiths[_currentIndex];
    final hadithName = _getHadithName(_currentIndex);

    final text = '''
الحديث ${hadith.numberInArabic}
$hadithName

${hadith.arabic}

من كتاب الأربعين النووية للإمام النووي رحمه الله
    ''';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            const Text('تم نسخ الحديث'),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
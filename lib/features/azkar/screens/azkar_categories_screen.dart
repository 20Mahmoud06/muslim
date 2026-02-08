import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../data/azkar_categories_data.dart';
import '../widgets/azkar_pattern_painter.dart';
import '../widgets/azkar_sliver_app_bar.dart';
import '../widgets/azkar_grid.dart';
import '../widgets/other_azkar_button.dart';
import 'azkar_detail_screen.dart';
import 'other_azkar_screen.dart';

class AzkarCategoriesScreen extends StatefulWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  State<AzkarCategoriesScreen> createState() => _AzkarCategoriesScreenState();
}

class _AzkarCategoriesScreenState extends State<AzkarCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Map<String, dynamic> _azkarData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadAzkarData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// تهيئة الأنيميشن
  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  /// تحميل بيانات الأذكار من JSON
  Future<void> _loadAzkarData() async {
    try {
      final String data = await rootBundle.loadString('assets/data/hisn_almuslim.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      // استبعاد الفئات غير المطلوبة
      for (var category in AzkarCategoriesData.excludedCategories) {
        jsonData.remove(category);
      }

      setState(() {
        _azkarData = jsonData;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      _handleLoadError(e);
    }
  }

  /// معالجة خطأ التحميل
  void _handleLoadError(Object error) {
    debugPrint('Error loading azkar data: $error');
    setState(() => _isLoading = false);
  }

  /// الانتقال إلى تفاصيل الفئة
  void _navigateToCategory(String title, List<Color> gradient, IconData icon) {
    if (_azkarData.containsKey(title)) {
      _navigateWithAnimation(
        AzkarDetailScreen(
          categoryTitle: title,
          categoryData: _azkarData[title],
          categoryGradient: gradient,
          categoryIcon: icon,
        ),
      );
    } else {
      _showCategoryNotFoundMessage();
    }
  }

  /// الانتقال إلى الأذكار الأخرى
  void _navigateToOtherAzkar() {
    final otherAzkar = _getOtherAzkar();
    _navigateWithAnimation(OtherAzkarScreen(azkarData: otherAzkar));
  }

  /// جمع الأذكار الأخرى
  Map<String, dynamic> _getOtherAzkar() {
    final Map<String, dynamic> otherAzkar = {};
    final mainTitles = AzkarCategoriesData.mainCategories
        .map((c) => c['title'] as String)
        .toList();

    _azkarData.forEach((key, value) {
      if (!mainTitles.contains(key)) {
        otherAzkar[key] = value;
      }
    });

    return otherAzkar;
  }

  /// الانتقال مع أنيميشن
  void _navigateWithAnimation(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// عرض رسالة عدم وجود الفئة
  void _showCategoryNotFoundMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'عذراً، هذا القسم غير متوفر حالياً',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'cairo'),
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading ? _buildLoadingIndicator() : _buildContent(),
    );
  }

  /// مؤشر التحميل
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
        strokeWidth: 3,
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildContent() {
    return Stack(
      children: [
        // الخلفية المزخرفة
        Positioned.fill(
          child: CustomPaint(
            painter: AzkarPatternPainter(),
          ),
        ),
        // المحتوى الرئيسي
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const AzkarSliverAppBar(),
            AzkarGrid(
              categories: AzkarCategoriesData.mainCategories,
              animationController: _animationController,
              onCategoryTap: _navigateToCategory,
            ),
            OtherAzkarButton(
              animationController: _animationController,
              onTap: _navigateToOtherAzkar,
            ),
          ],
        ),
      ],
    );
  }
}
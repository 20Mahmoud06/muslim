import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../model/allah_names_model.dart';

class NameDetailOverlay extends StatefulWidget {
  final AsmaaAllahModel name;
  final VoidCallback onClose;

  const NameDetailOverlay({
    super.key,
    required this.name,
    required this.onClose,
  });

  @override
  State<NameDetailOverlay> createState() => _NameDetailOverlayState();
}

class _NameDetailOverlayState extends State<NameDetailOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    _controller.reverse().then((_) => widget.onClose());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleClose,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.black.withOpacity(0.75),
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {}, // منع الإغلاق عند الضغط على الكارد نفسه
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                      maxWidth: 500.w,
                    ),
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.thirdColor,
                          AppColors.secondaryColor,
                          AppColors.primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زر الإغلاق
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: _handleClose,
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // العدد مع تصميم أفضل
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CustomText(
                              text: '${widget.name.id}',
                              fontSize: 26.sp,
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // الاسم بخط أكبر وأجمل
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: CustomText(
                              text: widget.name.name,
                              textAlign: TextAlign.center,
                              fontSize: 44.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          // خط فاصل جميل
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDividerDot(),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Container(
                                  height: 2.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.6),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _buildDividerDot(),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          // المعنى
                          _buildInfoSection(
                            title: 'المعنى',
                            content: widget.name.meaning,
                            icon: Icons.menu_book_rounded,
                          ),

                          if (widget.name.benefit != null &&
                              widget.name.benefit!.isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            _buildInfoSection(
                              title: 'البيان',
                              content: widget.name.benefit!,
                              icon: Icons.lightbulb_outline_rounded,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerDot() {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.9),
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: title,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: content,
            textAlign: TextAlign.center,
            fontSize: 17.sp,
            textColor: Colors.white.withOpacity(0.95),
            height: 1.9,
          ),
        ],
      ),
    );
  }
}
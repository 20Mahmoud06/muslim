import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/custom_text.dart';
import '../models/azkar_model.dart';

class ZikrCounter extends StatefulWidget {
  final Zikr zikr;
  final List<Color> gradient;
  final VoidCallback onTap;

  const ZikrCounter({
    super.key,
    required this.zikr,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<ZikrCounter> createState() => _ZikrCounterState();
}

class _ZikrCounterState extends State<ZikrCounter> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pulseController.forward().then((_) => _pulseController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 130.w,
          height: 130.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: widget.zikr.isCompleted
                  ? [Color(0xFF66BB6A), Color(0xFF4CAF50)]
                  : widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.zikr.isCompleted
                    ? Color(0xFF66BB6A)
                    : widget.gradient[0])
                    .withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.zikr.isCompleted) ...[
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 48.sp,
                ),
              ] else ...[
                CustomText(
                  text: '${widget.zikr.currentCount}',
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: 'من ${widget.zikr.count}',
                  fontSize: 14.sp,
                  textColor: Colors.white.withOpacity(0.9),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
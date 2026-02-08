import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';

class CounterCircle extends StatefulWidget {
  const CounterCircle({super.key});

  @override
  State<CounterCircle> createState() => _CounterCircleState();
}

class _CounterCircleState extends State<CounterCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        if (state is! TasbihLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<TasbihCubit>();

        return GestureDetector(
          onTap: () {
            cubit.incrementCounter();
            _animationController.forward().then(
                  (_) => _animationController.reverse(),
            );
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightGreen,
                    AppColors.thirdColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGreen.withOpacity(0.4),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: Center(
                child: CustomText(
                  text: state.counter.toString(),
                  fontSize: 72.sp,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
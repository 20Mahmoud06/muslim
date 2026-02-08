import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';
import '../widgets/tasbih_header.dart';
import '../widgets/tasbih_selection_list.dart';
import '../widgets/goal_selector.dart';
import '../widgets/counter_circle.dart';
import '../widgets/progress_indicator_widget.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasbihCubit(),
      child: BlocListener<TasbihCubit, TasbihState>(
        listener: (context, state) {
          if (state is TasbihGoalReached) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'مَا شَاءَ ٱللَّٰهُ 🎉 لقد أتممت هدفك!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'cairo',
                  ),
                ),
                backgroundColor: AppColors.primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Header with gradient
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const TasbihHeader(),
                      Positioned(
                        top: 200.h,
                        left: 0,
                        right: 0,
                        child: const TasbihSelectionList(),
                      ),
                    ],
                  ),

                  SizedBox(height: 50.h),

                  // Goal Selector
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const GoalSelector(),
                  ),

                  SizedBox(height: 30.h),

                  // Counter Circle
                  const CounterCircle(),

                  SizedBox(height: 32.h),

                  // Progress Bar
                  const ProgressIndicatorWidget(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
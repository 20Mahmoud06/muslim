import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        if (state is! TasbihLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<TasbihCubit>();
        int currentGoal = cubit.getCurrentGoal();
        double progress =
        currentGoal > 0 ? state.counter / currentGoal : 0.0;
        if (progress > 1.0) progress = 1.0;

        return Column(
          children: [
            Container(
              width: 0.85.sw,
              height: 10.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerRight,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.thirdColor, AppColors.lightGreen],
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            CustomText(
              text: '${state.counter} / $currentGoal',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
          ],
        );
      },
    );
  }
}
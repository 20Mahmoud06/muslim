import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';

class GoalSelector extends StatelessWidget {
  const GoalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        if (state is! TasbihLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<TasbihCubit>();

        return Column(
          children: [
            CustomText(
              text: 'إختر الهدف',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.goals.length + 2, // +2 for custom goals
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) {
                  bool isCustom1 = index == state.goals.length;
                  bool isCustom2 = index == state.goals.length + 1;
                  bool isSelected = state.goalIndex == index;

                  if (isCustom1 || isCustom2) {
                    return _buildCustomGoalButton(
                      context,
                      cubit,
                      state,
                      index,
                      isSelected,
                    );
                  }

                  return GestureDetector(
                    onTap: () => cubit.setGoal(index),
                    child: Container(
                      margin: EdgeInsets.only(left: 14.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.thirdColor
                          ],
                        )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.lightGrey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: state.goals[index].toString(),
                          fontSize: isSelected ? 20.sp : 18.sp,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                          textColor: isSelected ? Colors.white : AppColors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomGoalButton(
      BuildContext context,
      TasbihCubit cubit,
      TasbihLoaded state,
      int index,
      bool isSelected,
      ) {
    int customGoalValue = cubit.getCustomGoalValue();

    return GestureDetector(
      onTap: () => _showCustomGoalDialog(context, cubit, index),
      child: Container(
        margin: EdgeInsets.only(left: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [AppColors.primaryColor, AppColors.thirdColor],
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.lightGrey,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: isSelected ? Colors.white : AppColors.grey,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            CustomText(
              text: isSelected && customGoalValue > 0
                  ? customGoalValue.toString()
                  : 'مخصص',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              textColor: isSelected ? Colors.white : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomGoalDialog(
      BuildContext context,
      TasbihCubit cubit,
      int index,
      ) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(
          text: 'أدخل الهدف المخصص',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryColor,
        ),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'مثال: 70',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: CustomText(
              text: 'إلغاء',
              fontSize: 16.sp,
              textColor: AppColors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final goal = int.tryParse(textController.text);
              if (goal != null && goal > 0) {
                cubit.setCustomGoal(goal);
                cubit.setGoal(index);
                Navigator.of(dialogContext).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: CustomText(
              text: 'حفظ',
              fontSize: 16.sp,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
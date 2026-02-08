import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';

class TasbihSelectionList extends StatelessWidget {
  const TasbihSelectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        if (state is! TasbihLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<TasbihCubit>();

        return SizedBox(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.tasbihList.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final tasbih = state.tasbihList[index];
              bool isSelected = state.selectedTasbihIndex == index;

              if (tasbih.isCustom && tasbih.arabicText.isEmpty) {
                return _buildCustomTasbihButton(
                    context, cubit, index, isSelected);
              }

              return GestureDetector(
                onTap: () => cubit.selectTasbih(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: EdgeInsets.only(left: 14.w),
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  constraints: BoxConstraints(
                    maxWidth: 200.w,
                    minWidth: 80.w,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        AppColors.thirdColor,
                        AppColors.lightGreen,
                      ],
                    )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : AppColors.lightGrey,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.lightGreen.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomText(
                      text: tasbih.arabicText,
                      fontSize: isSelected ? 17.sp : 15.sp,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w600,
                      textColor:
                      isSelected ? Colors.white : AppColors.primaryColor,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCustomTasbihButton(
      BuildContext context,
      TasbihCubit cubit,
      int index,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () => _showCustomTasbihDialog(context, cubit, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        constraints: BoxConstraints(
          maxWidth: 100.w,
          minWidth: 80.w,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              AppColors.thirdColor,
              AppColors.lightGreen,
            ],
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.lightGrey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.lightGreen.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: isSelected ? Colors.white : AppColors.grey,
              size: 28.sp,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: 'إِضَافَةٌ',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: isSelected ? Colors.white : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomTasbihDialog(
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
          text: 'أَدْخِلِ ٱلذِّكْرَ ٱلْمُخَصَّصَ',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryColor,
        ),
        content: TextField(
          controller: textController,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: 'cairo',
          ),
          decoration: InputDecoration(
            hintText: 'مِثَالٌ: ٱللَّٰهُمَّ ٱغْفِرْ لِي',
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
              text: 'إِلْغَاءٌ',
              fontSize: 16.sp,
              textColor: AppColors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                cubit.editCustomTasbih(index, text);
                cubit.selectTasbih(index);
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
              text: 'حِفْظٌ',
              fontSize: 16.sp,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
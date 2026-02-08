import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';

class TasbihHeader extends StatelessWidget {
  const TasbihHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: -50.h,
                  right: -50.w,
                  child: Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30.h,
                  left: -30.w,
                  top: 90.h,
                  child: Container(
                    width: 150.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                // الأزرار العلوية - تفاعلية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 20.sp,),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomText(
                      text: 'السبحة الإلكترونية',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                    BlocBuilder<TasbihCubit, TasbihState>(
                      builder: (context, state) {
                        final cubit = context.read<TasbihCubit>();
                        return IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () => cubit.resetCounter(),
                        );
                      },
                    ),
                  ],
                ),

                // Selected Tasbih Display في النص
                // هنا المنطقة اللي اللمسات لازم تعدي منها للـ list
                Container(
                  height: 135.h,
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    child: Center(
                      child: BlocBuilder<TasbihCubit, TasbihState>(
                        builder: (context, state) {
                          if (state is! TasbihLoaded) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: CustomText(
                                text: 'ٱخْتَرْ ذِكْرًا',
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          if (state.tasbihList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: CustomText(
                                text: 'ٱخْتَرْ ذِكْرًا',
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          final tasbih = state.tasbihList[state.selectedTasbihIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomText(
                              text: tasbih.arabicText.isEmpty
                                  ? 'ٱخْتَرْ ذِكْرًا'
                                  : tasbih.arabicText,
                              fontSize: 21.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              textAlign: TextAlign.center,
                              maxLines: 4,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/qibla/qibla/qibla_cubit.dart';
import 'package:muslim/features/qibla/qibla/qibla_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class BuildLocationInfo extends StatelessWidget {
  const BuildLocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QiblaCubit, QiblaState>(
      builder: (context, state) {
        String cityName = 'جاري التحميل...';
        bool isLoading = true;

        if (state is QiblaReady) {
          cityName = state.cityName;
          isLoading = false;
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              isLoading
                  ? SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              )
                  : CustomText(
                text: cityName,
                fontSize: 13.sp,
                textColor: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        );
      },
    );
  }
}
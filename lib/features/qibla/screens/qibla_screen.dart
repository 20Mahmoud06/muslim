import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/qibla/qibla/qibla_cubit.dart';
import 'package:muslim/features/qibla/qibla/qibla_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../widgets/build_error.dart';
import '../widgets/build_loading.dart';
import '../widgets/qibla_compass_custom.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QiblaCubit()..checkQiblaStatus(),
      child: const _QiblaScreenView(),
    );
  }
}

class _QiblaScreenView extends StatelessWidget {
  const _QiblaScreenView();

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(
          text: title,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          textColor: AppColors.primaryColor,
        ),
        content: CustomText(
          text: message,
          fontSize: 14.sp,
          textColor: AppColors.grey,
          height: 1.5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
            child: CustomText(
              text: 'حسناً',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                text: 'تنبيه',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                textColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        content: CustomText(
          text:
          'لقد تم رفض إذن الموقع بشكل دائم.\nيجب تفعيله من إعدادات التطبيق للمتابعة.',
          fontSize: 14.sp,
          textColor: AppColors.grey,
          height: 1.6,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<QiblaCubit>().retry();
            },
            child: CustomText(
              text: 'إلغاء',
              fontSize: 14.sp,
              textColor: AppColors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<QiblaCubit>().openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: CustomText(
              text: 'فتح الإعدادات',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CustomText(
          text: 'اتجاه القبلة',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
      ),
      body: BlocConsumer<QiblaCubit, QiblaState>(
        listener: (context, state) {
          if (state is QiblaDeviceNotSupported) {
            _showErrorDialog(
              context,
              'خطأ في الجهاز',
              state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is QiblaLoading || state is QiblaInitial) {
            return const BuildLoading();
          }

          if (state is QiblaDeviceNotSupported) {
            return BuildError(
              title: 'خطأ في الجهاز',
              message: state.message,
              buttonText: 'رجوع',
              onPressed: () => Navigator.pop(context),
            );
          }

          if (state is QiblaLocationServiceDisabled) {
            return BuildError(
              title: 'خدمة الموقع معطلة',
              message: state.message,
              buttonText: 'فتح الإعدادات',
              onPressed: () => context.read<QiblaCubit>().openLocationSettings(),
            );
          }

          if (state is QiblaPermissionDenied) {
            return BuildError(
              title: 'تم رفض الإذن',
              message: state.message,
              buttonText: 'طلب الإذن',
              onPressed: () async {
                await context.read<QiblaCubit>().requestPermission();

                // فحص إذا الحالة تغيرت لـ deniedForever
                final currentState = context.read<QiblaCubit>().state;
                if (currentState is QiblaPermissionDeniedForever) {
                  _showPermissionDialog(context);
                }
              },
            );
          }

          if (state is QiblaPermissionDeniedForever) {
            return BuildError(
              title: 'الإذن مرفوض بشكل دائم',
              message: state.message,
              buttonText: 'فتح الإعدادات',
              onPressed: () => context.read<QiblaCubit>().openAppSettings(),
            );
          }

          if (state is QiblaError) {
            return BuildError(
              title: 'خطأ',
              message: state.message,
              buttonText: 'إعادة المحاولة',
              onPressed: () => context.read<QiblaCubit>().retry(),
            );
          }

          if (state is QiblaReady) {
            return const QiblaCompassCustom();
          }

          return const BuildLoading();
        },
      ),
    );
  }
}
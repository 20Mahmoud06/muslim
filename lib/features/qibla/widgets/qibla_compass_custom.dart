import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/qibla/widgets/build_additional_info.dart';
import 'package:muslim/features/qibla/widgets/build_direction_info.dart';
import 'package:muslim/features/qibla/widgets/build_location_info.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import 'compass_painter.dart';

class QiblaCompassCustom extends StatelessWidget {
  const QiblaCompassCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return Center(
            child: CustomText(
              text: 'لا يمكن تحديد اتجاه القبلة',
              fontSize: 16.sp,
              textColor: AppColors.grey,
            ),
          );
        }

        final isAligned = (qiblahDirection.offset.abs() < 5);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColor.withOpacity(0.05),
                AppColors.background,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // معلومات الموقع
              BuildLocationInfo(),

              SizedBox(height: 16.h),

              // معلومات الاتجاه
              BuildDirectionInfo(
                qiblahDirection: qiblahDirection,
                isAligned: isAligned,
              ),

              SizedBox(height: 32.h),

              // البوصلة المرسومة
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 300.w,
                    height: 300.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // البوصلة الدوارة
                        CustomPaint(
                          size: Size(300.w, 300.w),
                          painter: CompassPainter(
                            angle: qiblahDirection.direction,
                          ),
                        ),

                        // أيقونة الكعبة في المنتصف
                        Transform.rotate(
                          angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.secondaryColor,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset('assets/icons/kaaba.png',width: 50.w,),
                          ),
                        ),

                        // السهم المؤشر للقبلة
                        Positioned(
                          top: 20.h,
                          child: Transform.rotate(
                            angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightGreen.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.navigation_rounded,
                                size: 40.sp,
                                color: AppColors.lightGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // معلومات إضافية
              BuildAdditionalInfo(qiblahDirection: qiblahDirection),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
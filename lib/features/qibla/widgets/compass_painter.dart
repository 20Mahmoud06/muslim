import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CompassPainter extends CustomPainter {
  final double angle;

  CompassPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // رسم الدائرة الخارجية
    final outerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final shadowPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // رسم الظل
    canvas.drawCircle(center, radius + 5, shadowPaint);

    // رسم الدائرة الخارجية
    canvas.drawCircle(center, radius, outerCirclePaint);

    // رسم الدائرة الخارجية بحدود
    final borderPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // رسم الدائرة الداخلية
    final innerCirclePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primaryColor.withOpacity(0.05),
          AppColors.lightGreen.withOpacity(0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius - 40))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 40, innerCirclePaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-angle * pi / 180);

    // رسم خطوط البوصلة
    _drawCompassLines(canvas, radius);

    // رسم الاتجاهات الرئيسية
    _drawDirectionLabels(canvas, radius);

    canvas.restore();
  }

  void _drawCompassLines(Canvas canvas, double radius) {
    final mainLinePaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final secondaryLinePaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final smallLinePaint = Paint()
      ..color = AppColors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // رسم 72 خط (كل 5 درجات)
    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * pi / 180;
      final isMainLine = i % 18 == 0; // كل 90 درجة
      final isSecondaryLine = i % 9 == 0; // كل 45 درجة

      Paint paint;
      double startRadius;
      double endRadius;

      if (isMainLine) {
        paint = mainLinePaint;
        startRadius = radius - 50;
        endRadius = radius - 25;
      } else if (isSecondaryLine) {
        paint = secondaryLinePaint;
        startRadius = radius - 45;
        endRadius = radius - 30;
      } else {
        paint = smallLinePaint;
        startRadius = radius - 40;
        endRadius = radius - 33;
      }

      final start = Offset(
        cos(angle) * startRadius,
        sin(angle) * startRadius,
      );
      final end = Offset(
        cos(angle) * endRadius,
        sin(angle) * endRadius,
      );

      canvas.drawLine(start, end, paint);
    }

    // رسم مثلث الشمال باللون الأحمر
    final northPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.fill;

    final northPath = Path();
    northPath.moveTo(0, -(radius - 20));
    northPath.lineTo(-8, -(radius - 40));
    northPath.lineTo(8, -(radius - 40));
    northPath.close();
    canvas.drawPath(northPath, northPaint);
  }

  void _drawDirectionLabels(Canvas canvas, double radius) {
    final textStyle = TextStyle(
      color: AppColors.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final directions = ['N', 'E', 'S', 'W'];
    final arabicDirections = ['ش', 'ر', 'ج', 'غ'];

    for (int i = 0; i < 4; i++) {
      final angle = i * 90 * pi / 180 - pi / 2;
      final x = cos(angle) * (radius - 60);
      final y = sin(angle) * (radius - 60);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-(-this.angle * pi / 180 + angle + pi / 2));

      final textSpan = TextSpan(
        text: '${directions[i]}\n${arabicDirections[i]}',
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
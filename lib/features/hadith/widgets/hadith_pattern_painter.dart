import 'package:flutter/material.dart';
import 'dart:math' as math;

class HadithPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // رسم نمط هندسي إسلامي (نجوم ثمانية متداخلة)
    final cellSize = 90.0;
    final rows = (size.height / cellSize).ceil();
    final cols = (size.width / cellSize).ceil();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final x = j * cellSize + cellSize / 2;
        final y = i * cellSize + cellSize / 2;

        // رسم نجمة ثمانية
        _drawIslamicStar(canvas, paint, Offset(x, y), cellSize / 3.2);

        // رسم دائرة حول النجمة
        canvas.drawCircle(
          Offset(x, y),
          cellSize / 3.8,
          Paint()
            ..color = Colors.white.withOpacity(0.02)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }

    // إضافة زخارف دائرية متداخلة في الزاوية
    final accentPaint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 6; i++) {
      final radius = 100.0 + (i * 40);
      canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.15),
        radius,
        accentPaint,
      );
    }

    // رسم أقواس زخرفية في الزاوية الأخرى
    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (int i = 0; i < 4; i++) {
      final radius = 120.0 + (i * 50);
      final rect = Rect.fromCircle(
        center: Offset(size.width * 0.1, size.height * 0.8),
        radius: radius,
      );
      canvas.drawArc(
        rect,
        -math.pi / 4,
        math.pi / 2,
        false,
        arcPaint,
      );
    }

    // إضافة نقاط زخرفية صغيرة
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (i % 6) * (size.width / 5);
      final y = (i ~/ 6) * (size.height / 5);
      canvas.drawCircle(
        Offset(x + 20, y + 20),
        3.0,
        dotPaint,
      );
    }
  }

  void _drawIslamicStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    final points = 8;
    final angleStep = (2 * math.pi) / points;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - math.pi / 2;
      final r = i.isEven ? radius : radius * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);

    // رسم دائرة صغيرة في المنتصف
    canvas.drawCircle(
      center,
      radius * 0.15,
      Paint()
        ..color = Colors.white.withOpacity(0.04)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
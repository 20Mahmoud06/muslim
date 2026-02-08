import 'dart:math' as math;
import 'package:flutter/material.dart';

/// رسام الزخرفة الإسلامية لصفحة الأذكار
/// يرسم نجوماً إسلامية ثمانية ونجوماً صغيرة
class AzkarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 50.0;

    // رسم نجوم إسلامية ثمانية
    for (double i = 0; i < size.width + spacing; i += spacing) {
      for (double j = 0; j < size.height + spacing; j += spacing) {
        _drawIslamicStar(canvas, Offset(i, j), 12, paint);
      }
    }

    // رسم نجوم صغيرة في المنتصف
    final smallPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (double i = spacing / 2; i < size.width; i += spacing) {
      for (double j = spacing / 2; j < size.height; j += spacing) {
        _drawSmallStar(canvas, Offset(i, j), 4, smallPaint);
      }
    }
  }

  /// رسم نجمة إسلامية ثمانية
  void _drawIslamicStar(
      Canvas canvas,
      Offset center,
      double radius,
      Paint paint,
      ) {
    const int points = 8;
    final Path path = Path();
    const pi = 3.14159265359;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? radius : radius / 2;
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
  }

  /// رسم نجمة صغيرة رباعية
  void _drawSmallStar(
      Canvas canvas,
      Offset center,
      double radius,
      Paint paint,
      ) {
    const int points = 4;
    final Path path = Path();
    const pi = 3.14159265359;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? radius : radius / 2.5;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
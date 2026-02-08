import 'package:flutter/material.dart';
import 'dart:math' as math;

class EmptySpacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // رسم أقواس ودوائر زخرفية
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // دائرة مركزية
    canvas.drawCircle(
      Offset(centerX, centerY),
      40,
      paint,
    );

    // أقواس حول الدائرة
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final startAngle = angle - math.pi / 16;
      final sweepAngle = math.pi / 8;

      final rect = Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: 60,
      );

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }

    // نجوم صغيرة في الأركان
    _drawSmallStar(canvas, paint, Offset(30, 30), 15);
    _drawSmallStar(canvas, paint, Offset(size.width - 30, 30), 15);
  }

  void _drawSmallStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    final points = 6;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
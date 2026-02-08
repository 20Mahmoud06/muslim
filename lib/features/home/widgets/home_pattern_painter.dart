import 'package:flutter/material.dart';

class HomePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final squarePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const squareSpacing = 70.0;

    for (double i = 0; i < size.width + squareSpacing; i += squareSpacing) {
      for (double j = 0; j < size.height + squareSpacing; j += squareSpacing) {
        _drawRotatedSquares(canvas, Offset(i, j), 18, squarePaint);
      }
    }

    // الطبقة الثانية: معينات صغيرة
    final diamondPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const diamondSpacing = 45.0;

    for (double i = diamondSpacing / 2; i < size.width; i += diamondSpacing) {
      for (double j = diamondSpacing / 2; j < size.height; j += diamondSpacing) {
        _drawSimpleDiamond(canvas, Offset(i, j), 10, diamondPaint);
      }
    }

    // الطبقة الثالثة: نقاط زينة صغيرة جداً
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    const dotSpacing = 25.0;

    for (double i = 12.5; i < size.width; i += dotSpacing) {
      for (double j = 12.5; j < size.height; j += dotSpacing) {
        canvas.drawCircle(Offset(i, j), 1.5, dotPaint);
      }
    }
  }

  /// رسم مربعات دوارة متداخلة
  void _drawRotatedSquares(
      Canvas canvas,
      Offset center,
      double size,
      Paint paint,
      ) {
    // المربع الأول (عادي)
    final rect1 = Rect.fromCenter(
      center: center,
      width: size * 2,
      height: size * 2,
    );
    canvas.drawRect(rect1, paint);

    // المربع الثاني (مدور 45 درجة)
    final path = Path();
    final rotatedSize = size * 1.4;

    path.moveTo(center.dx, center.dy - rotatedSize);
    path.lineTo(center.dx + rotatedSize, center.dy);
    path.lineTo(center.dx, center.dy + rotatedSize);
    path.lineTo(center.dx - rotatedSize, center.dy);
    path.close();

    canvas.drawPath(path, paint);

    // مربع صغير في المنتصف
    final innerRect = Rect.fromCenter(
      center: center,
      width: size,
      height: size,
    );
    canvas.drawRect(innerRect, paint);
  }

  /// رسم معين بسيط
  void _drawSimpleDiamond(
      Canvas canvas,
      Offset center,
      double size,
      Paint paint,
      ) {
    final path = Path();

    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
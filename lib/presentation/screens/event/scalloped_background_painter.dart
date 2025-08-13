import 'package:flutter/material.dart';

class ScallopedBackgroundPainter extends CustomPainter {
  ScallopedBackgroundPainter({
    required this.color,
    this.overlap = 0.3,
    this.count,
    this.diameter,
  });

  final Color color;
  final double overlap;
  final int? count;
  final double? diameter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (count != null && diameter != null) {
      final double r = (diameter ?? size.height) / 2;
      final int n = count!;
      final double step = (size.width - (2 * r)) / (n - 1);
      final double cy = size.height / 2;
      for (int i = 0; i < n; i++) {
        final double cx = r + i * step;
        canvas.drawCircle(Offset(cx, cy), r, paint);
      }
    } else {
      final double r = size.height / 2;
      final double diameter = r * 2;
      final double clampedOverlap = overlap.clamp(0.0, 0.9);
      final double step = diameter * (1 - clampedOverlap);

      final double startX = -r;
      final double endX = size.width + r;
      int iStart = ((startX - r) / step).floor();
      int iEnd = ((endX - r) / step).ceil();

      for (int i = iStart; i <= iEnd; i++) {
        final double cx = i * step + r;
        canvas.drawCircle(Offset(cx, r), r, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ScallopedBackgroundPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.overlap != overlap ||
        oldDelegate.count != count ||
        oldDelegate.diameter != diameter;
  }
}
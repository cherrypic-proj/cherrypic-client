import 'package:flutter/material.dart';

/// 구름 모양 Title 배경
class ScallopedBackgroundPainter extends CustomPainter {
  ScallopedBackgroundPainter({
    required this.color,
    this.overlap = 0.3,     /// 원 사이의 겹침 정도
    this.count,             /// 원 개수
    this.diameter,          /// 원의 지름
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

    /// 개수가 지정된 경우 → 고정 개수만큼
    if (count != null && diameter != null) {
      _drawFixedCountCircles(canvas, size, paint);
    }
    /// 개수 지정이 아니라면 너비에 맞게 자동으로 원을 반복해서 그림
    else {
      _drawAutoCircles(canvas, size, paint);
    }

    canvas.restore();
  }

  /// 원의 개수가 지정된 경우, 일정 간격으로 정해진 개수만큼 원 그리기
  void _drawFixedCountCircles(Canvas canvas, Size size, Paint paint) {
    final double r = (diameter ?? size.height) / 2;
    final double d = r * 2;
    final int n = count!;
    final double step = (size.width - d) / (n - 1);
    final double cy = size.height / 2;

    for (int i = 0; i < n; i++) {
      final double cx = r + i * step;
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  /// 원의 개수가 지정되지 않은 경우, 화면 너비에 맞춰 원 그리기
  void _drawAutoCircles(Canvas canvas, Size size, Paint paint) {
    final double r = size.height / 2;
    final double d = r * 2;
    final double clampedOverlap = overlap.clamp(0.0, 0.9);
    final double step = d * (1 - clampedOverlap);

    final double startX = -r;
    final double endX = size.width + r;
    final int iStart = ((startX - r) / step).floor();
    final int iEnd = ((endX - r) / step).ceil();

    for (int i = iStart; i <= iEnd; i++) {
      final double cx = i * step + r;
      canvas.drawCircle(Offset(cx, r), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScallopedBackgroundPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.overlap != overlap ||
        oldDelegate.count != count ||
        oldDelegate.diameter != diameter;
  }
}
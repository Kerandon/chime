import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CustomClockSolid extends CustomPainter {
  final double percentage;
  final Color dashColor;
  final Color backgroundColor;
  final double scaleMultiplier;

  CustomClockSolid({
    required this.percentage,
    required this.backgroundColor,
    required this.dashColor,
    this.scaleMultiplier = 1.0
  });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.55, centerY * 0.55);
    final strokeWidth = size.width * 0.08;

    /// BACKGROUND
    var paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2,
          math.pi * 2);

    canvas.drawPath(path, paint);

    /// CIRCLE
    var linePaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final linePath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2,
          math.pi * 2);

    ui.PathMetrics pathMetrics = linePath.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted =
        pathMetric.extractPath(0.0, pathMetric.length * percentage);

    canvas.drawPath(extracted, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

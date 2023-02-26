import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../configs/constants.dart';

class CustomClockSolid extends CustomPainter {
  final double percentage;
  final Color dashColor;
  final Color backgroundColor;
  final double strokeWidthDash;

  CustomClockSolid({
    this.percentage = 0.50,
    this.backgroundColor = Colors.white54,
    this.dashColor = Colors.blue,
    this.strokeWidthDash = kSessionTimerStrokeWidth * 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    print('percent $percentage and adjusted $adjustedPercent');

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.50, centerY * 0.50);

    /// BACKGROUND
    var paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

    final path = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2,
          math.pi * 2);

    canvas.drawPath(path, paint);

    /// CIRCLE
    var linePaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

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
    return false;
  }
}

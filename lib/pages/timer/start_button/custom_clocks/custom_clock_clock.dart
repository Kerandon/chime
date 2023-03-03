import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../configs/constants.dart';

class CustomClockClock extends CustomPainter {
  final double percentage;
  final Color fillColor;
  final Color borderColor;
  final double strokeWidthDash;

  CustomClockClock({
    required this.percentage,
    required this.fillColor,
    required this.borderColor,
    this.strokeWidthDash = kSessionTimerStrokeWidth * 0.60,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.50, centerY * 0.50);
    double dotBuffer = size.width * 0.01;
    int dotBufferMultiplier = 4;

    /// DASHES SMALL

    var dashBrushSmall = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (double i = -90; i < 360; i += 6) {
      dotBuffer = 1;
      if (i % 30 == 0) {
        dotBuffer = 3;
      }
      var x1 = center.dx + (radius) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius) * math.sin(i * math.pi / 180);

      var x2 = center.dx +
          (radius + dotBuffer * dotBufferMultiplier) *
              math.cos(i * math.pi / 180);
      var y2 = center.dy +
          (radius + dotBuffer * dotBufferMultiplier) *
              math.sin(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushSmall);
    }

    /// CIRCLE
    var circlePaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidthDash * 1.5;

    final circlePath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius * 0.88),
          -math.pi / 2, math.pi * 2);

    ui.PathMetrics pathMetrics = circlePath.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted =
        pathMetric.extractPath(0.0, pathMetric.length * percentage);

    canvas.drawPath(extracted, circlePaint);

    /// BORDER CIRCLES
    var borderCirclePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidthDash / 10;

    final outerLinePath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius * 0.98),
          -math.pi / 2, math.pi * 2);

    canvas.drawPath(outerLinePath, borderCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

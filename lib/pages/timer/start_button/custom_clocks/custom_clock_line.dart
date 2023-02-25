import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../configs/constants.dart';

class CustomClockLine extends CustomPainter {
  final double percentage;
  final Color dashColor;
  final Color backgroundColor;
  final double strokeWidthDash;

  CustomClockLine(
      {required this.percentage,
        required this.backgroundColor,
        required this.dashColor,
        this.strokeWidthDash = kSessionTimerStrokeWidth * 0.60,
      });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    print('percent $percentage and adjusted $adjustedPercent');

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.50, centerY * 0.50);


    /// CIRCLE
    var paint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;



    final path = Path()
    ..addOval(Rect.fromCircle(center: center, radius: radius));

    ui.PathMetrics pathMetrics = path.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted = pathMetric.extractPath(
        0.0, pathMetric.length * percentage);

    canvas.drawPath(extracted, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

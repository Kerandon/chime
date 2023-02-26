import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../configs/constants.dart';

class CustomClockDash extends CustomPainter {
  final double percentage;
  final Color dashColor;
  final Color backgroundColor;
  final double strokeWidthDash;

  CustomClockDash(
      {required this.percentage,
      required this.backgroundColor,
      required this.dashColor,
      this.strokeWidthDash = kSessionTimerStrokeWidth * 0.60,
      });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.50, centerY * 0.50);
    double dotBuffer = size.width * 0.03;
    int dotBufferMultiplier = 4;
    int numberOfDashesMultiplier = 18; /// 360 / 6 = 60;

    /// Dash Background
    var dashBrushBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

    for (double i = -90; i < 360; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius + dotBuffer) * math.sin(i * math.pi / 180);

      var x2 =
          center.dx + (radius + dotBuffer * dotBufferMultiplier) * math.cos(i * math.pi / 180);
      var y2 =
          center.dy + (radius + dotBuffer * dotBufferMultiplier) * math.sin(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
    }

    ///

    var dashBrush = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

    for (double i = -90; i < adjustedPercent; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius + dotBuffer) * math.sin(i * math.pi / 180);

      var x2 =
          center.dx + (radius + dotBuffer * dotBufferMultiplier) * math.cos(i * math.pi / 180);
      var y2 =
          center.dy + (radius + dotBuffer * dotBufferMultiplier) * math.sin(i * math.pi / 180);



      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

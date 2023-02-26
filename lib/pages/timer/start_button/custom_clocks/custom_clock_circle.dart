import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomClockCircle extends CustomPainter {
  final double percentage;
  final Color dashColor;
  final Color backgroundColor;

  CustomClockCircle(
      {this.percentage = 0.50,
        this.backgroundColor = Colors.white54,
        this.dashColor = Colors.blue,
      });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * 0.50, centerY * 0.50);
    double dotBuffer = size.width * 0.03;
    int numberOfDashesMultiplier = 18; /// 360 / 6 = 60;

    /// Dash Background
    var dashBrushBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    for (double i = -90; i < 360; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius + dotBuffer) * math.sin(i * math.pi / 180);
      canvas.drawCircle(Offset(x1,y1), size.width * 0.06, dashBrushBackground);
    }

    ///

    var dashBrush = Paint()
      ..color = dashColor
      ..style = PaintingStyle.fill;

    for (double i = -90; i < adjustedPercent; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius + dotBuffer) * math.sin(i * math.pi / 180);
      canvas.drawCircle(Offset(x1,y1), size.width * 0.06, dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomClockCircle extends CustomPainter {
  final double percentage;
  final Color circlesColor;
  final Color backgroundColor;
  final double radius;

  CustomClockCircle({
    required this.percentage,
    required this.circlesColor,
    required this.backgroundColor,
    this.radius = 0.45,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);
    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double adjustedRadius = math.min(centerX * radius , centerY * radius);
    double dotBuffer = size.width * 0.03;
    int numberOfDashesMultiplier = 18;

    /// 360 / 6 = 60;

    /// Circle Background
    var dashBrushBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    for (double i = -90; i < 360; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (adjustedRadius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (adjustedRadius + dotBuffer) * math.sin(i * math.pi / 180);
      canvas.drawCircle(Offset(x1, y1), size.width * 0.06, dashBrushBackground);
    }

    /// Circles

    var dashBrush = Paint()
      ..color = circlesColor
      ..style = PaintingStyle.fill;

    for (double i = -90; i < adjustedPercent; i += numberOfDashesMultiplier) {
      var x1 = center.dx + (adjustedRadius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (adjustedRadius + dotBuffer) * math.sin(i * math.pi / 180);
      canvas.drawCircle(Offset(x1, y1), size.width * 0.06, dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

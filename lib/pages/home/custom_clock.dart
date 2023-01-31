import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';
import '../../configs/constants.dart';

class CustomClock extends CustomPainter {
  final double percentage;
  final Color handColor;
  final Color dashColor;
  final Color circleColor;
  final double strokeWidthHand;
  final double strokeWidthDash;

  CustomClock(
      {required this.percentage,
      required this.circleColor,
      required this.handColor,
      required this.dashColor,
      this.strokeWidthHand = kSessionTimerStrokeWidth * 0.35,
      this.strokeWidthDash = kSessionTimerStrokeWidth * 0.50});

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX, centerY);
    double dotBuffer = size.width * 0.05;

    // var handX = center.dx + radius * math.cos(adjustedPercent * math.pi / 180);
    // var handY = center.dy + radius * math.sin(adjustedPercent * math.pi / 180);
    // //
    // // var paintHand = Paint()
    // //   ..strokeWidth = strokeWidthHand
    // //   ..strokeCap = StrokeCap.round
    // //   ..color = handColor
    // //   ..style = PaintingStyle.stroke;
    // //
    // // var path = Path();
    // //
    // // path.moveTo(center.dx, center.dy);
    // // path.lineTo(handX, handY);

    /// Dash Background
    var dashBrushBackground = Paint()
      ..color = AppColors.darkGrey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

    for (double i = -90; i < 360; i += 6) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dx + (radius + dotBuffer) * math.sin(i * math.pi / 180);

      var x2 =
          center.dx + (radius + dotBuffer * 3) * math.cos(i * math.pi / 180);
      var y2 =
          center.dx + (radius + dotBuffer * 3) * math.sin(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
    }

    ///

    var dashBrush = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthDash;

    for (double i = -90; i < adjustedPercent; i += 6) {
      var x1 = center.dx + (radius + dotBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dx + (radius + dotBuffer) * math.sin(i * math.pi / 180);

      var x2 =
          center.dx + (radius + dotBuffer * 3) * math.cos(i * math.pi / 180);
      var y2 =
          center.dx + (radius + dotBuffer * 3) * math.sin(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushBackground);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

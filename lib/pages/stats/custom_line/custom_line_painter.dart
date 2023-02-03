import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../models/data_point.dart';

class LinePainter extends CustomPainter {
  final List<MapEntry<String, double>> axisX, axisY;
  final List<DataPoint> dataPoints;
  final double percent;

  LinePainter({
    required this.axisX,
    required this.axisY,
    required this.dataPoints,
    required this.percent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    const double widthIndentation = 0.10;
    const double heightIndentation = 0.93;

    var axisPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    ///X & Y AXIS
    Path axisPath = Path()
      ..moveTo(width * widthIndentation, (heightIndentation * height))
      ..lineTo(width * widthIndentation, 0)
      ..moveTo(width * widthIndentation, (heightIndentation * height))
      ..lineTo(width, heightIndentation * height);
    canvas.drawPath(axisPath, axisPaint);

    /// X AXIS LABEL
    for (int i = 0; i < axisX.length; i++) {
      TextSpan span = TextSpan(
          text: axisX.elementAt(i).key,
          style: TextStyle(color: Colors.grey[600]));
      TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout(maxWidth: width * 0.20);
      textPainter.paint(
          canvas,
          Offset((axisX.elementAt(i).value * width * 0.75) + width * 0.10,
              height * (heightIndentation * 1.01) ));
    }

    /// Y AXIS LABEL
    for (int i = 0; i < axisY.length; i++) {
      TextSpan span = TextSpan(
          text: axisY.elementAt(i).key,
          style: TextStyle(color: Colors.grey[600]));
      TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout(
          maxWidth: (size.width * widthIndentation) * 0.90,
          minWidth: (size.width * widthIndentation) * 0.90);
      textPainter.paint(
          canvas,
          Offset(
              0,
              ((size.height - ((size.height * 1)* axisY.elementAt(i).value)) *
                  heightIndentation)));
    }

    /// Progress Line
    var paintLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(widthIndentation * width, height - (dataPoints.first.y * height));
    for (var d in dataPoints) {
      print('data point to add ${d.x} and ${d.y}');
      path.lineTo(d.x * ((1.0 - widthIndentation) * width) + (widthIndentation * width), height - (d.y * height));
    }

    ui.PathMetrics pathMetrics = path.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted = pathMetric.extractPath(0.0, pathMetric.length * percent);

    canvas.drawPath(extracted, paintLine);

    //canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


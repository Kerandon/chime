import 'dart:ui' as ui;
import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';

import '../../../models/data_point.dart';
import '../../../utils/methods/create_painted_text.dart';

class LinePainter extends CustomPainter {
  final List<SeriesPoint> seriesData;
  final List<String> labelsX, labelsY;
  final double percent;
  final Color lineColor;
  final Color axisColor;
  final double lineWidth;
  final TextStyle textStyle;

  LinePainter(
      {required this.seriesData,
      required this.percent,
      required this.labelsX,
      required this.labelsY,
      this.lineColor = Colors.teal,
      this.axisColor = Colors.grey,
      this.lineWidth = kChartBarLineWidth,
      this.textStyle = const TextStyle()});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    double widthIndent = width * 0.06;
    double adjustedWidth = width - widthIndent;
    double heightIndent = height * 0.94;
    double adjustedHeight = height - heightIndent;

    /// CHART LINE
    ///

    if (seriesData.isNotEmpty) {
      var paintLine = Paint()
        ..color = lineColor
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

      Path path = Path();

      path.moveTo(widthIndent, height - (seriesData.first.dataY * height));
      for (var d in seriesData) {
        path.lineTo(d.dataX * (adjustedWidth) + widthIndent,
            height - (d.dataY * height));
      }

      ui.PathMetrics pathMetrics = path.computeMetrics();
      ui.PathMetric pathMetric = pathMetrics.elementAt(0);
      Path extracted = pathMetric.extractPath(0.0, pathMetric.length * percent);

      canvas.drawPath(extracted, paintLine);
    }

    ///X & Y AXIS LINES

    var axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 0.50
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path axisPath = Path()
      ..moveTo(widthIndent - 5, heightIndent)
      ..lineTo(widthIndent, 0)
      ..moveTo(widthIndent - 5, heightIndent)
      ..lineTo(width, heightIndent);
    canvas.drawPath(axisPath, axisPaint);

    /// X LABELS MARKERS

    if (seriesData.isNotEmpty) {
      double labelSpacingX = adjustedWidth / kNoOfXLabelsOnLineChart;
      var xLabelPaint = Paint()
        ..color = Colors.white54
        ..strokeWidth = 6
        ..style = PaintingStyle.fill;

      Path xLabelPath = Path();
      for (int i = 0; i < labelsX.length; i++) {
        xLabelPath = Path()
          ..addOval(Rect.fromCircle(
              center: Offset(
                  widthIndent + (labelSpacingX * i) + (labelSpacingX),
                  height - (adjustedHeight)),
              radius: size.width * 0.003));
        canvas.drawPath(xLabelPath, xLabelPaint);


        /// X LABELS TEXT
        var textWidth = size.width * 0.10;
        createPaintedText(labelsX[i],
            canvas: canvas,
            minWidth: textWidth,
            maxWidth: textWidth,
            textStyle: textStyle,
            offset: Offset(
                (widthIndent +
                    (labelSpacingX * i) +
                    (labelSpacingX / 2) -
                    (textWidth / 2)),
                height - size.height * 0.05),
            textAlign: TextAlign.center);
      }

      /// Y LABELS

      for (int i = 0; i < labelsY.length; i++) {
        double spacing = heightIndent / 5;

        createPaintedText(labelsY[i],
            canvas: canvas,
            offset: Offset(
              widthIndent - size.width * 0.07,
              (spacing * i) - size.width * 0.02,
            ),
            maxWidth: adjustedWidth * 0.25,
            textStyle: textStyle);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

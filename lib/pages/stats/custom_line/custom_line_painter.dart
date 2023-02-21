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

  LinePainter({required this.seriesData,
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
    final axisLineAdjustment = size.width * 0.005;
    double widthIndent = width * 0.06;
    double adjustedWidth = width - widthIndent;
    double actualHeight = height * 0.94;
    double adjustedHeight = height - actualHeight;
    double markerRadius = 0.004;

    /// CHART LINE

    if (seriesData.isNotEmpty) {
      var paintLine = Paint()
        ..color = lineColor
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      Path path = Path();

      path.moveTo(
          widthIndent, actualHeight - (seriesData.first.dataY * actualHeight));
      for (var d in seriesData) {
        path.lineTo(d.dataX * (adjustedWidth) + widthIndent,
            actualHeight - ((d.dataY * actualHeight))
        );
      }
      ui.PathMetrics pathMetrics = path.computeMetrics();

      ui.PathMetric pathMetric = pathMetrics.elementAt(0);
      Path extracted = pathMetric.extractPath(
          0.0, pathMetric.length * percent);

      canvas.drawPath(extracted, paintLine);
    }

    ///X & Y AXIS LINES

    var axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 0.50
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path axisPath = Path()
      ..moveTo(widthIndent - axisLineAdjustment, actualHeight)
      ..lineTo(widthIndent - axisLineAdjustment, 0)
      ..moveTo(widthIndent - axisLineAdjustment, actualHeight)
      ..lineTo(width - axisLineAdjustment, actualHeight);
    canvas.drawPath(axisPath, axisPaint);

    /// X LABELS MARKERS

    if (seriesData.isNotEmpty) {
      double labelSpacingX = adjustedWidth / kNoOfXLabelsOnLineChart;
      var markerPaint = Paint()
        ..strokeWidth = 1
        ..style = PaintingStyle.fill;

      Path labelMarks = Path();
      for (int i = 0; i < labelsX.length; i++) {
        labelMarks = Path()
          ..addOval(Rect.fromCircle(
              center: Offset(
                  widthIndent + (labelSpacingX * i) + (labelSpacingX),
                  height - (adjustedHeight)),
              radius: size.width * markerRadius));
        canvas.drawPath(labelMarks, markerPaint);

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
                actualHeight + size.height * 0.02),
            textAlign: TextAlign.center);
      }

      /// Y LABELS

      for (int i = 0; i < labelsY.length; i++) {
        double spacing = actualHeight / 5;

        createPaintedText(labelsY[i],
            canvas: canvas,
            offset: Offset(widthIndent - size.width * 0.085,
                (spacing * i) -
                    ///Push up a little to center for text height
                    (size.height * 0.03)),
            maxWidth: widthIndent,
            minWidth: widthIndent,
            textStyle: textStyle,
            textAlign: TextAlign.right);

        /// Y MARKERS

        final yMarkerPath = Path()
          ..addOval(
              Rect.fromCircle(center: Offset(widthIndent - axisLineAdjustment,
                  actualHeight - (spacing * i)),
                  radius: size.width * markerRadius));

        canvas.drawPath(yMarkerPath, markerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

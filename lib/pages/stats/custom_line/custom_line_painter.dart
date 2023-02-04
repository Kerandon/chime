import 'dart:ui' as ui;
import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';

import '../../../models/data_point.dart';

class LinePainter extends CustomPainter {
  final List<SeriesPoint> seriesData;
  final double percent;
  final Color lineColor;
  final Color axisColor;
  final double lineWidth;
  final TextStyle textStyle;

  LinePainter(
      {required this.seriesData,
      required this.percent,
      this.lineColor = Colors.teal,
      this.axisColor = Colors.grey,
      this.lineWidth = kChartBarLineWidth,
      this.textStyle = const TextStyle()});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    double widthIndent = width * 0.06;
    double heightIndent = height * 0.94;

    /// CHART LINE
    if (seriesData.isNotEmpty) {
      var paintLine = Paint()
        ..color = lineColor
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      Path path = Path();

      path.moveTo(widthIndent, height - (seriesData.first.dataY * height));
      for (var d in seriesData) {
        path.lineTo(d.dataX * (width - widthIndent) + widthIndent,
            height - (d.dataY * height));
      }

      ui.PathMetrics pathMetrics = path.computeMetrics();
      ui.PathMetric pathMetric = pathMetrics.elementAt(0);
      Path extracted = pathMetric.extractPath(0.0, pathMetric.length * percent);

      canvas.drawPath(extracted, paintLine);

      var axisPaint = Paint()
        ..color = axisColor
        ..strokeWidth = 0.50
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      ///X & Y AXIS LINES
      Path axisPath = Path()
        // ..moveTo(widthIndent, heightIndent)
        // ..lineTo(widthIndent, 0)
        ..moveTo(widthIndent, heightIndent)
        ..lineTo(width, heightIndent);
      canvas.drawPath(axisPath, axisPaint);

      /// X AXIS LABELS

      for (int i = 0; i < seriesData.length; i++) {
        createPaintedText(
          seriesData[i].xLabel,
          canvas: canvas,
          offset: Offset(
            (seriesData[i].dataX * (width * 0.82)) + widthIndent,
            heightIndent * 1.01,
          ),
          minWidth: widthIndent * 4,
          maxWidth: widthIndent * 4,
          textStyle: textStyle
        );

        /// Y AXIS LABELS
        createPaintedText(seriesData[i].yLabel,
            canvas: canvas,
            offset: Offset(seriesData[i].dataX * (width - (widthIndent * 1.5)), (height - (seriesData[i].dataY * height))),
            minWidth: widthIndent,
            maxWidth: widthIndent,
            textAlign: TextAlign.right,
            textStyle: textStyle
        );
      }

      /// ZERO ON Y AXIS

      // createPaintedText('0',
      //     canvas: canvas,
      //     offset: Offset(0, (heightIndent * 0.98)),
      //     minWidth: widthIndent ,
      //     maxWidth: widthIndent,
      //     textAlign: TextAlign.right);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void createPaintedText(
  String? text, {
  required Canvas canvas,
  required Offset offset,
  double? minWidth,
  double? maxWidth,
  TextAlign textAlign = TextAlign.left,
  TextStyle? textStyle,
}) {
  TextSpan span = TextSpan(text: text, style: textStyle);
  TextPainter textPainter = TextPainter(
    text: span,
    textAlign: textAlign,
    textDirection: ui.TextDirection.ltr,
  );
  textPainter.layout(minWidth: minWidth ?? 0.0, maxWidth: maxWidth ?? 0.0);

  textPainter.paint(
    canvas,
    offset,
  );
}

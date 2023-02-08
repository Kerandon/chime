import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../models/data_point.dart';
import '../../../utils/methods/create_painted_text.dart';

class TextOnLinePainter extends CustomPainter {
  final List<SeriesPoint> seriesData;
  final String text;
  final TextStyle textStyle;

  TextOnLinePainter({
    required this.seriesData,
    required this.text,
    required this.textStyle,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final width = size.width;
    final height = size.height;
    double widthIndent = width * 0.06;
    double adjustedWidth = width - widthIndent;

    createPaintedText(
      text,
      canvas: canvas,
      offset: Offset(
          ((seriesData.last.dataX * adjustedWidth) + widthIndent) -
              (adjustedWidth * 0.05),
          height - (seriesData.last.dataY * height) - (height * 0.08)),
      minWidth: size.width * 0.20,
      maxWidth: size.width * 0.20,
      textAlign: TextAlign.left,
      textStyle: textStyle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

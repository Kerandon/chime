import 'package:chime/configs/constants.dart';
import 'package:chime/models/data_point.dart';
import 'package:chime/pages/stats/custom_line/text_on_line_end.dart';
import 'package:chime/utils/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'custom_line_painter.dart';

class AnimatedLineChart extends StatefulWidget {
  const AnimatedLineChart({
    Key? key,
    required this.seriesData,
    this.animate = false,
    this.animateOnStart = false,
    required this.labelsX,
    required this.labelsY,
    required this.maxRangeY,
  }) : super(key: key);

  final List<SeriesPoint> seriesData;
  final List<String> labelsX;
  final List<String> labelsY;
  final int maxRangeY;
  final bool animate, animateOnStart;

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showEndLineText = false;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)..addListener(() {
          if(_controller.value == 1.0){
            _showEndLineText = true;
            setState(() {

            });
          }
          if(_controller.value != 1.0){
            _showEndLineText = false;
            setState(() {

            });
          }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedLineChart oldWidget) {
    _animate();
    super.didUpdateWidget(oldWidget);
  }

  void _animate() {
    if (!_controller.isAnimating && widget.animate) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SeriesPoint> dataPoints = [];
    dataPoints =
        setChartPoints(seriesData: widget.seriesData, maxRangeY: widget.maxRangeY).toList();

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          children: [
            dataPoints.isEmpty
                ? Center(
                    child: Text(
                    kNoChartDataMsg,
                    style: Theme.of(context).textTheme.bodySmall,
                  )).animate().fadeIn()
                : const SizedBox.shrink(),
            Stack(
              children: [
              CustomPaint(
                  painter: LinePainter(
                    seriesData: dataPoints,
                    labelsX: widget.labelsX,
                    labelsY: widget.labelsY,
                    percent: _controller.value,
                    lineColor: Theme.of(context).primaryColor,
                    axisColor: Theme.of(context).secondaryHeaderColor,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 10,
                        ),
                  ),
                  child: Container(),
                ),
                _showEndLineText ?   CustomPaint(
                  painter: TextOnLinePainter(seriesData: dataPoints,
                      text: (widget.maxRangeY * dataPoints.last.dataY).toInt().formatToHourMin(),
                      textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500
                      )
                  ),
                  child: Container(),
                ).animate().fadeIn() : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<SeriesPoint> setChartPoints(
      {required List<SeriesPoint> seriesData, required int maxRangeY}) {
    List<SeriesPoint> data = [];
    if (seriesData.isNotEmpty) {
      double maxRangeX = seriesData.last.dataX;


      /// DRAW POINTS PROPORTIONALLY IF >= 4;
      double fraction = 1.0;

      if (seriesData.length <= 8) {
        fraction = (seriesData.length / 2) / kNoOfXLabelsOnLineChart;
      }

      for (int i = 0; i < seriesData.length; i++) {
        data.add(SeriesPoint((seriesData[i].dataX / maxRangeX) * fraction,
            seriesData[i].dataY / maxRangeY));
      }
    }

    return data;
  }
}

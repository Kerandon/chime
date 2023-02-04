import 'package:chime/configs/constants.dart';
import 'package:chime/models/data_point.dart';
import 'package:flutter/material.dart';
import 'custom_line_painter.dart';

class AnimatedLineChart extends StatefulWidget {
  const AnimatedLineChart({
    Key? key,
    required this.seriesData,
  }) : super(key: key);

  final List<SeriesPoint> seriesData;

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SeriesPoint> dataPoints = setChartPoints(widget.seriesData).toList();
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => SizedBox(
          child: CustomPaint(
            painter: LinePainter(
              seriesData: dataPoints,
              percent: _controller.value,
              lineColor: Theme.of(context).primaryColor,
              axisColor: Theme.of(context).secondaryHeaderColor,
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: kChartAxisFontSize,
              )
            ),
            child: Container(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: const Text('Play'),
      ),
    );
  }

  List<SeriesPoint> setChartPoints(List<SeriesPoint> seriesData) {
    List<SeriesPoint> data = [];

    if (seriesData.isNotEmpty) {
      final maxRangeX = seriesData.last.dataX;
      final maxRangeY = seriesData.last.dataY;

      for (var d in seriesData) {
        data.add(SeriesPoint(
            d.dataX / maxRangeX, d.dataY / maxRangeY, d.xLabel, d.yLabel));
      }
    }
    return data;
  }
}

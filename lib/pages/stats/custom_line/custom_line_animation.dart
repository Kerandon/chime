import 'package:chime/models/data_point.dart';
import 'package:chime/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/stats_model.dart';
import '../../../chart_page.dart';
import 'custom_line_painter.dart';

class LinePainterAnimation extends StatefulWidget {
  const LinePainterAnimation({Key? key, required this.stats}) : super(key: key);

  final List<StatsModel> stats;

  @override
  State<LinePainterAnimation> createState() => _LinePainterAnimationState();
}

class _LinePainterAnimationState extends State<LinePainterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String oldestDateString = "";
  String latestDateString = "";
  final List<MapEntry<String, double>> _axisY = [];
  final List<MapEntry<String, double>> _axisX = [];
  List<DataPoint> dataPoints = [];
  int daysRange = 0;
  double intervalY = 1;

  Path path = Path();

  @override
  void initState() {
    widget.stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final oldestDate = widget.stats.first.dateTime;
    final recentDate = widget.stats.last.dateTime;

    DateFormat formatter = DateFormat.yM();
    oldestDateString = formatter.format(oldestDate);
    latestDateString = formatter.format(recentDate);

    daysRange = recentDate.difference(oldestDate).inDays;
    int totalTime = stats.fold(
        0,
        (previousValue, element) =>
            previousValue + element.totalMeditationTime);

    int maxTimeY = totalTime;
    if (maxTimeY <= 600) {
      maxTimeY = 600;
    } else {
      // int n = (maxTimeY + 300) ~/ 240;
      // maxTimeY = n * 240;
    }

    _axisX.addAll(
        [MapEntry(oldestDateString, 0), MapEntry(latestDateString, 1.0)]);

    _axisY.addAll([
      const MapEntry('0', 0.02),
      MapEntry(totalTime.formatToHourMin(), totalTime / maxTimeY),
      MapEntry(maxTimeY.formatToHourMin(), 1.0)
    ]);

    int runningTotal = 0;
    for (var s in stats) {
      runningTotal += s.totalMeditationTime;
      var y = runningTotal / maxTimeY;
      var x = s.dateTime.difference(oldestDate).inDays / daysRange;
      dataPoints.add(DataPoint(x, y));
    }

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Center(
          child: Container(
            color: Colors.white10,
            width: size.width * 0.90,
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: LinePainter(
                  axisX: _axisX,
                  axisY: _axisY,
                  dataPoints: dataPoints,
                  percent: _controller.value,
                ),
                child: Container(),
              ),
            ),
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
}

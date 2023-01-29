import 'package:chime/enums/time_period.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/utils/methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../../models/stats_model.dart';

FlBorderData get borderData => FlBorderData(
      show: false,
      border: Border.all(color: Colors.transparent),
    );

class TotalTimeChart extends ConsumerStatefulWidget {
  const TotalTimeChart({
    super.key,
  });

  @override
  ConsumerState<TotalTimeChart> createState() => _TotalTimeChartState();
}

class _TotalTimeChartState extends ConsumerState<TotalTimeChart> {
  late final Future<List<StatsModel>> _statsFuture;

  @override
  void initState() {
    _statsFuture = DatabaseManager().getStatsByTimePeriod(
        period: TimePeriod.allTime, allTimeGroupedByDay: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(kPageIndentation * size.width),
      child: FutureBuilder<List<StatsModel>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          double totalTime = 0;
          List<StatsModel> data = [];
          List<StatsModel> testData = [];
          List<LineChartAxis> axisData = [];
          if (snapshot.hasData) {
            data = snapshot.data!;

            testData = [
              StatsModel(
                  dateTime: DateTime(2022, 11, 01), totalMeditationTime: 50),
              StatsModel(
                  dateTime: DateTime(2022, 03, 01), totalMeditationTime: 30),
              StatsModel(
                  dateTime: DateTime(2022, 01, 01), totalMeditationTime: 50),
              StatsModel(
                  dateTime: DateTime(2023, 01, 01), totalMeditationTime: 15),
              StatsModel(
                  dateTime: DateTime(2022, 12, 19), totalMeditationTime: 120),
              StatsModel(
                  dateTime: DateTime(2022, 12, 19), totalMeditationTime: 0),
            ];

            _addTodayDate(testData);

            testData.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            for (int i = 0; i < testData.length; i++) {
              double difference3 = testData[i]
                  .dateTime
                  .difference(testData.first.dateTime)
                  .inDays
                  .toDouble();
              totalTime += testData[i].totalMeditationTime.toDouble();
              axisData.add(
                LineChartAxis(difference3, totalTime),
              );
            }
          }

          double interval = 120;
          if (totalTime <= 600) {
            interval = 60;
          } else if (totalTime > 600) {
            int divided = (totalTime ~/ 5);
            var i = (divided / 60).roundToDouble() * 60;

            interval = i;
          }

          return SizedBox(
            height: size.height * 0.50,
            child: LineChart(
              LineChartData(
                borderData: borderData,
                gridData: FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    interval: interval,
                    reservedSize: 30,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String formatted = value.toInt().formatToHour();
                      if (value == meta.max) {
                        formatted = "";
                      }
                      return Text(formatted, style: Theme.of(context).textTheme.bodySmall,);
                    },
                  )),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                      isStrokeCapRound: true,
                      curveSmoothness: 0.20,
                      dotData: FlDotData(show: false),
                      barWidth: 8,
                      isCurved: true,
                      spots: axisData.map((e) {
                        return FlSpot(e.x, e.y);
                      }).toList()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _addTodayDate(List<StatsModel> testData) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final hasTodayDate = testData.any((element) => element.dateTime == today);
    if (!hasTodayDate) {
      testData.add(StatsModel(dateTime: today, totalMeditationTime: 0));
    }
  }
}

class LineChartAxis {
  final double x;
  final double y;

  LineChartAxis(this.x, this.y);
}

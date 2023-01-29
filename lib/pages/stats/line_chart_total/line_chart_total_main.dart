import 'dart:async';

import 'package:chime/enums/time_period.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/utils/methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
          double totalMeditationTime = 0;
          double intervalX = 150;
          double intervalY = 60;
          List<StatsModel> data = [];
          List<LineChartAxis> axisData = [];
          if (snapshot.hasData) {
            data = snapshot.data!.toList();
            List<StatsModel> test = [];
            _addTodaysDate(data);

            data.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            for (int i = 0; i < data.length; i++) {
              double difference3 = data[i]
                  .dateTime
                  .difference(data.first.dateTime)
                  .inDays
                  .toDouble();
              totalMeditationTime += data[i].totalMeditationTime.toDouble();
              axisData.add(
                LineChartAxis(difference3, totalMeditationTime),
              );
            }

            int totalDuration =
                data.last.dateTime.difference(data.first.dateTime).inDays;

            if (totalDuration <= 365) {
              intervalX = 150;
            } else if (totalDuration > 365) {
              intervalX = totalDuration / 5;
            }

            if (totalMeditationTime <= 600) {
              intervalY = 60;
            } else if (totalMeditationTime > 600) {
              int divided = (totalMeditationTime ~/ 5);
              intervalY = (divided / 60).roundToDouble() * 60;
            }
          }

          return SizedBox(
            height: size.height * 0.50,
            child: LineChart(
              swapAnimationDuration: Duration.zero,
              LineChartData(
                borderData: borderData,
                gridData: FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: intervalY,
                      reservedSize: 30,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String formatted = value.toInt().formatToHour();
                        if (value == meta.max) {
                          formatted = "";
                        }
                        return Text(
                          formatted,
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        reservedSize: 50,
                        interval: intervalX,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String formattedDate = "";
                          double invertedValue = meta.max - value;
                          DateTime dateX = DateTime.now();
                          if (meta.max != value) {
                            dateX = dateX.copyWith(day: -invertedValue.toInt());
                            final formatter = DateFormat.yM();
                            formattedDate = formatter.format(dateX);
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              formattedDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        }),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      barWidth: 2,
                      spots: axisData.map(
                        (e) {
                          return FlSpot(e.x, e.y);
                        },
                      ).toList())
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _addTodaysDate(List<StatsModel> testData) {
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

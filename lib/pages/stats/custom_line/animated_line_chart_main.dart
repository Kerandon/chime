import 'package:chime/state/chart_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../../configs/constants.dart';
import '../../../enums/time_period.dart';
import '../../../models/data_point.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_manager.dart';
import 'animated_line_chart.dart';
import '../last_medition_time_title.dart';

class AnimatedLineChartMain extends ConsumerStatefulWidget {
  const AnimatedLineChartMain({
    super.key,
  });

  @override
  ConsumerState<AnimatedLineChartMain> createState() =>
      _AnimatedLineChartMainState();
}

class _AnimatedLineChartMainState extends ConsumerState<AnimatedLineChartMain> {
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
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    bool animate = false;
    if (state.pageScrollOffset / size.width > 1.3) {
      animate = true;
    } else {
      animate = false;
    }

    return FutureBuilder(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StatsModel> stats = [];
            List<SeriesPoint> seriesData = [], stepChart = [];
            List<String> labelsX = [], labelsY = [];
            int maxRangeY = 0;
            if (snapshot.data!.isNotEmpty) {
              stats = snapshot.data!.toList();
              stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
              seriesData = _calculateSeriesData(stats).toList();
              stepChart = _convertDataToStepChart(seriesData).toList();
              labelsX = _calculateLabelsX(stats: stats).toList();
              Tuple2 resultY = _calculateLabelsY(seriesData);
              labelsY = resultY.item1;
              maxRangeY = resultY.item2;

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                notifier.setTotalMeditationTime(seriesData.last.dataY.toInt());
              });
            }

            return Column(
              children: [
                const Expanded(
                    flex: 3,
                    child: LastMeditationTimeTitle()),
                Expanded(
                  flex: 5,
                  child: AnimatedLineChart(
                    animate: animate,
                    seriesData: stepChart,
                    labelsX: labelsX,
                    labelsY: labelsY,
                    maxRangeY: maxRangeY,
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  List<SeriesPoint> _calculateSeriesData(List<StatsModel> stats) {
    var oldestDateX = stats.first.dateTime;
    List<SeriesPoint> seriesData = [];
    int runningTotalY = 0;
    for (int i = 0; i < stats.length; i++) {
      var x = stats[i].dateTime.difference(oldestDateX).inDays;
      runningTotalY += stats[i].totalMeditationTime;

      seriesData.add(SeriesPoint(x.toDouble(), runningTotalY.toDouble()));
    }

    for(var s in seriesData){
      print('${s.dataX} and nnn ${s.dataY}');
    }

    return seriesData;
  }

  List<String> _calculateLabelsX({required List<StatsModel> stats}) {
    var oldestDateX = stats.first.dateTime;
    List<DateTime> labelsXDateTime = [];
    DateTime latestDateX = stats.last.dateTime;
    int daysBetweenDates = latestDateX.difference(oldestDateX).inDays;



    /// ALWAYS ADD THE OLDEST DATE IF NOT EMPTY
    /// AND ALWAYS ADD OLDEST AND NEWEST DATE IF SERIES >= 2;

    if (stats.isNotEmpty) {
      labelsXDateTime.add(oldestDateX);
    }
    if (stats.length > 1) {
      labelsXDateTime.add(latestDateX);
    }

    /// CALCULATE INBETWEEN VALUES FOR SERIES >= 3 and <=5
    if (stats.length >= 3 && stats.length <= 5) {
      var divider = daysBetweenDates / (stats.length - 1);
      for (int i = 0; i < stats.length - 2; i++) {
        var d = DateTime(oldestDateX.year, oldestDateX.month,
            oldestDateX.day + (divider * (i + 1)).toInt());
        labelsXDateTime.add(d);
      }
    }

    /// AND CALCULATE FOR ALL VALUES ABOVE 5
    if (stats.length > 5) {
      int divider = daysBetweenDates ~/ (kNoOfXLabelsOnLineChart - 1);
      for (int i = 1; i < kNoOfXLabelsOnLineChart - 1; i++) {
        var d = DateTime(oldestDateX.year, oldestDateX.month,
            oldestDateX.day + (divider * i));
        labelsXDateTime.add(d);
      }
    }

    /// SORT AND FORMAT
    DateFormat formatter;
    if(daysBetweenDates <= 7){
      formatter = DateFormat.E();
    }else if(daysBetweenDates > 7 && daysBetweenDates <= 124){
      formatter = DateFormat.MMMd();
    }else{
      formatter = DateFormat.yMMM();
    }

    labelsXDateTime.sort((a, b) => a.compareTo(b));
    List<String> formatted = [];
    for (var d in labelsXDateTime) {
      formatted.add(formatter.format(d));
    }
    return formatted;
  }

  Tuple2<List<String>, int> _calculateLabelsY(List<SeriesPoint> seriesData) {
    List<String> labelsY = [];
    int noOfHours = (seriesData.last.dataY.toInt() + 600) ~/ 60;

    int maxRangeY = (noOfHours * 60);
    int divided = maxRangeY ~/ 5;

    for (int i = 0; i < 6; i++) {
      labelsY.add((divided * i).formatToHourMin());
    }
    labelsY = labelsY.reversed.toList();
    print('max range here is ${maxRangeY}');
    return Tuple2(labelsY, maxRangeY);
  }

  List<SeriesPoint> _convertDataToStepChart(List<SeriesPoint> seriesData) {
    List<SeriesPoint> stepChart = [];

    stepChart.addAll(seriesData);

    for (int i = 0; i < seriesData.length - 1; i++) {
      stepChart.insert(
          i + i + 1, SeriesPoint(seriesData[i + 1].dataX, seriesData[i].dataY));
    }

    for(var s in stepChart){
      print('stepchart ${s.dataX} and ${s.dataY}');
    }

    return stepChart;
  }
}

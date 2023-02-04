import 'package:chime/state/chart_state.dart';
import 'package:chime/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../enums/time_period.dart';
import '../../../models/data_point.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_manager.dart';
import 'animated_line_chart.dart';

class AnimatedLineChartMain extends ConsumerStatefulWidget {
  const AnimatedLineChartMain({
    super.key,
  });

  @override
  ConsumerState<AnimatedLineChartMain> createState() => _AnimatedLineChartMainState();
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
    final notifier = ref.read(chartStateProvider.notifier);
    return FutureBuilder(
        future: _statsFuture,
        builder: (context, snapshot) {
          List<SeriesPoint> seriesData = [];
          List<StatsModel> stats = [];
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            stats = snapshot.data!;


            stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
            DateTime oldestDateX = stats.first.dateTime;
            DateFormat formatter = DateFormat.yM();

            int runningTotalY = 0;

            for (int i = 0; i < stats.length; i++) {
              var x = stats[i].dateTime.difference(oldestDateX).inDays;
              runningTotalY += stats[i].totalMeditationTime;

              String? labelX, labelY;

              if (i == 0 || i == stats.length - 1) {
                labelX = formatter.format(stats[i].dateTime);
              }
              if (i == stats.length - 1) {
                labelY = runningTotalY.formatToHourMin();
              }
              seriesData.add(SeriesPoint(
                  x.toDouble(), runningTotalY.toDouble(), labelX, labelY));
            }
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              notifier.setTotalMeditationTime(runningTotalY);
            });


          }

          return AnimatedLineChart(
            seriesData: seriesData,
          );
        });
  }
}

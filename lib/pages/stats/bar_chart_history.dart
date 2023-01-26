import 'package:chime/configs/constants.dart';
import 'package:chime/enums/time_period.dart';
import 'package:chime/models/stats_model.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../configs/app_colors.dart';
import 'history_chart_touch_data.dart';

class BarChartHistory extends ConsumerStatefulWidget {
  const BarChartHistory({
    super.key,
  });

  @override
  ConsumerState<BarChartHistory> createState() => _BarChartHistoryState();
}

class _BarChartHistoryState extends ConsumerState<BarChartHistory> {
  List<StatsModel> stats = [];
  bool _futureHasRun = false;
  Future<List<StatsModel>>? _statsFuture;

  bool _animate = false;
  bool _showLabels = false;
  List<BarChartGroupData> bars = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.03;
    final state = ref.watch(stateProvider);

    if (!_futureHasRun) {
      _statsFuture = DatabaseManager().getStats(state.barChartTimePeriod);
      _futureHasRun = true;
    }

    return Column(
      children: [
        SizedBox(
          height: size.height * 0.40,
          width: size.width * 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widthPadding, size.height * 0.08, widthPadding, widthPadding),
            child: FutureBuilder<List<StatsModel>>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bars = _getBarData(snapshot.data!, state.barChartTimePeriod);
                    if (!_animate) {
                      _runAnimation();
                    }
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BarChart(
                            BarChartData(
                              barTouchData:
                                  getBarTouchData(showLabels: _showLabels),
                              gridData: FlGridData(show: false),
                              alignment: BarChartAlignment.spaceAround,
                              borderData: borderData,
                              barGroups: bars,
                              titlesData: titlesData,
                            ),
                            swapAnimationDuration: const Duration(
                              milliseconds: kChartAnimationDuration,
                            ),
                            swapAnimationCurve: Curves.easeOutQuint,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                }),
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    DateTime date = stats[value.toInt()].dateTime;
    final state = ref.watch(stateProvider);
    String format = 'EE';
    if (state.barChartTimePeriod == TimePeriod.week) {
      format = 'EE';
    } else if (state.barChartTimePeriod == TimePeriod.monthly) {
      format = 'MMM';
    }

    String formattedDate = DateFormat(format).format(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formattedDate,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: AppColors.offWhite, fontSize: 10),
      ),
    );
  }

  get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> _getBarData(
      List<StatsModel> statsData, TimePeriod period) {
    stats.clear();
    Set<StatsModel> allTimePoints = {};
    DateTime now = DateTime.now();
    for (var s in statsData) {
      stats.add(s);
    }

    if (period == TimePeriod.week) {
      for (int i = 0; i < 7; i++) {
        allTimePoints.add(StatsModel(
            dateTime: DateTime(now.year, now.month, now.day - i),
            totalMeditationTime: 0));
      }
    } else if (period == TimePeriod.monthly) {
      for (int i = 0; i < 12; i++) {
        allTimePoints.add(StatsModel(
            dateTime: DateTime.now().copyWith(month: DateTime.now().month - i),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.monthly));
      }
    }

    stats.addAll(allTimePoints.toSet().difference(stats.toSet()).toList());
    stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return stats
        .map(
          (e) => BarChartGroupData(
            x: stats.indexOf(e),
            barRods: [
              BarChartRodData(
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: e.totalMeditationTime.toDouble(),
                      color: Colors.transparent),
                  toY: _animate ? e.totalMeditationTime.toDouble() : 0),
            ],
            showingTooltipIndicators: e.totalMeditationTime > 0 ? [0] : null,
          ),
        )
        .toList();
  }

  _runAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animate = true;

        setState(() {});
      }
    });
    Future.delayed(
        const Duration(
          milliseconds: kChartAnimationDuration ~/ 1.5,
        ), () {
      if (mounted) {
        _showLabels = true;

        setState(() {});
      }
    });
  }
}

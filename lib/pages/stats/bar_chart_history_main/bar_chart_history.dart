import 'package:chime/configs/constants.dart';
import 'package:chime/enums/time_period.dart';
import 'package:chime/models/stats_model.dart';
import 'package:chime/state/chart_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/methods/methods.dart';
import 'bar_touch_data.dart';

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
  bool displayNoData = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * kPageIndentation;
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    if (!_futureHasRun) {
      _statsFuture = DatabaseManager()
          .getStatsByTimePeriod(period: state.barChartTimePeriod);
      _futureHasRun = true;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
          widthPadding, size.height * 0.01, widthPadding, size.height * 0.01),
      child: FutureBuilder<List<StatsModel>>(
        future: _statsFuture,
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            if (!_animate) {
              _runAnimation();
            }
            if (snapshot.data!.isNotEmpty) {
              bars = _getBarData(snapshot.data!, state.barChartTimePeriod).toList();
              if(state.barChartStats.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  notifier.setBarChartStats(stats);
                });
              }
            } else {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  displayNoData = true;
                });

            }
          }

          return Stack(
            children: [
              displayNoData ?  Center(
                child: Text(
                  kNoChartDataMsg,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ).animate().fadeIn() : const SizedBox.shrink(),
              BarChart(
                BarChartData(
                  barTouchData: getBarTouchData(showLabels: _showLabels),
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
            ],
          );
        },
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    DateTime date = stats[value.toInt()].dateTime;
    final state = ref.watch(chartStateProvider);
    String formatted = 'EE';
    if (state.barChartTimePeriod == TimePeriod.week) {
      formatted = DateFormat('EE').format(date);
    } else if (state.barChartTimePeriod == TimePeriod.fortnight) {
      formatted = DateFormat('d').format(date);
      var suffix = int.parse(formatted).addDateSuffix();
      formatted = '$formatted$suffix';
    } else if (state.barChartTimePeriod == TimePeriod.year) {
      formatted = DateFormat('MMM').format(date);
    } else if (state.barChartTimePeriod == TimePeriod.allTime) {
      formatted = DateFormat('y').format(date);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formatted,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(fontSize: kChartLabelsFontSize),
      ),
    ).animate().fadeIn();
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
        show: true,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).secondaryHeaderColor, width: 0.50),
        ),
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
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime(now.year, now.month, now.day - i),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.week,
          ),
        );
      }
    } else if (period == TimePeriod.fortnight) {
      for (int i = 0; i < 14; i++) {
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime(now.year, now.month, now.day - i),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.fortnight,
          ),
        );
      }
    } else if (period == TimePeriod.year) {
      for (int i = 0; i < 12; i++) {
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime.now()
                .copyWith(month: DateTime.now().month - i, day: 01),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.year,
          ),
        );
      }
    }

    final diff = allTimePoints.toSet().difference(stats.toSet()).toList();
    stats.addAll(diff);
    stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    int allTimeIndex = -1;

    return stats.map(
      (e) {
        allTimeIndex++ - 1;
        return BarChartGroupData(
          x: period == TimePeriod.allTime ? allTimeIndex : stats.indexOf(e),
          barRods: [
            BarChartRodData(
                width: kChartBarLineWidth,
                color: Theme.of(context).primaryColor,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: e.totalMeditationTime.toDouble(),
                  color: Colors.transparent,
                ),
                toY: _animate ? e.totalMeditationTime.toDouble() : 0),
          ],
          showingTooltipIndicators: e.totalMeditationTime > 0 ? [0] : null,
        );
      },
    ).toList();
  }

  _runAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animate = true;

        setState(() {});
      }
    });
    Future.delayed(
      const Duration(
        milliseconds: kChartAnimationDuration ~/ 1.5,
      ),
      () {
        if (mounted) {
          _showLabels = true;

          setState(() {});
        }
      },
    );
  }
}

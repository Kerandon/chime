import 'package:chime/models/stats_model.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/utils/methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../configs/app_colors.dart';

class BarChartHistory extends ConsumerStatefulWidget {
  const BarChartHistory({
    super.key,
  });

  @override
  ConsumerState<BarChartHistory> createState() => _BarChartHistoryState();
}

class _BarChartHistoryState extends ConsumerState<BarChartHistory> {
  late final Future<List<StatsModel>> _statsFuture;
  List<StatsModel> statsByDay = [];

  @override
  void initState() {
    super.initState();
    _statsFuture = DatabaseManager().getStats();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.01;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          widthPadding, size.height * 0.08, widthPadding, widthPadding),
      child: FutureBuilder<List<StatsModel>>(
          future: _statsFuture,
          builder: (context, snapshot) {
            List<BarChartGroupData> bars = [];
            if (snapshot.hasData) {
              bars = _getBarData(snapshot.data!);
            }

            return BarChart(
              BarChartData(
                barTouchData: barTouchData,
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                borderData: borderData,
                barGroups: bars,
                titlesData: titlesData,
              ),
            );
          }),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            String time = formatMinToHourMin(rod.toY.round());
            return BarTooltipItem(
              time,
              TextStyle(color: AppColors.offWhite, fontSize: 10),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    print('value $value');

    DateTime date = statsByDay[value.toInt()].dateTime;
    final formattedDate = DateFormat('EE').format(date);

    print(statsByDay[2].dateTime);

    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(formattedDate,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: AppColors.offWhite, fontSize: 12)));
  }

  get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: getTitles)),
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

  List<BarChartGroupData> _getBarData(List<StatsModel> statsData) {
    statsByDay.clear();
    Set<DateTime> allDaysMeditated = {};

    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      allDaysMeditated.add(DateTime(now.year, now.month, now.day - i));
    }
    for (var e in statsData) {
      allDaysMeditated
          .add(DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day));
    }

    for (var e in allDaysMeditated) {
      final matches = statsData.where((element) =>
          DateTime(element.dateTime.year, element.dateTime.month,
              element.dateTime.day) ==
          DateTime(e.year, e.month, e.day));

      int totalDailyTime = 0;
      for (var t in matches) {
        totalDailyTime += t.totalMeditationTime;
      }

      statsByDay
          .add(StatsModel(dateTime: e, totalMeditationTime: totalDailyTime));

      statsByDay.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      statsByDay.takeWhile((value) =>
          (value.dateTime.day > (DateTime.now().day) - 7) &&
          (value.dateTime.day <= (DateTime.now().day)));
    }

    return statsByDay
        .map(
          (e) => BarChartGroupData(
            x: statsByDay.indexOf(e),
            barRods: [
              BarChartRodData(
                toY: e.totalMeditationTime.toDouble(),
              ),
            ],
            showingTooltipIndicators: e.totalMeditationTime > 0 ? [0] : null,
          ),
        )
        .toList();
  }
}

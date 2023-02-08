import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/time_period.dart';
import '../models/stats_model.dart';

class ChartState {
  final int totalMeditationTime;
  final bool toggleBarChart;
  final TimePeriod barChartTimePeriod;
  final double pageScrollOffset;
  final List<StatsModel> barChartStats;
  final bool drawLineChart;
  final bool lineChartHasBeenDrawn;

  ChartState({
    required this.totalMeditationTime,
    required this.toggleBarChart,
    required this.barChartTimePeriod,
    required this.pageScrollOffset,
    required this.barChartStats,
    required this.drawLineChart,
    required this.lineChartHasBeenDrawn,
  });

  ChartState copyWith({
    int? totalMeditationTime,
    bool? toggleBarChart,
    TimePeriod? barChartTimePeriod,
    double? pageScrollOffset,
    List<StatsModel>? barChartStats,
    bool? drawLineChart,
    bool? lineChartHasBeenDrawn,
  }) {
    return ChartState(
      totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
      toggleBarChart: toggleBarChart ?? this.toggleBarChart,
      barChartTimePeriod: barChartTimePeriod ?? this.barChartTimePeriod,
      pageScrollOffset: pageScrollOffset ?? this.pageScrollOffset,
      barChartStats: barChartStats ?? this.barChartStats,
      drawLineChart: drawLineChart ?? this.drawLineChart,
      lineChartHasBeenDrawn:
          lineChartHasBeenDrawn ?? this.lineChartHasBeenDrawn,
    );
  }
}

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier(state) : super(state);

  setBarChartToggle() {
    state = state.copyWith(toggleBarChart: !state.toggleBarChart);
  }

  void setBarChartTimePeriod(TimePeriod time) {
    state = state.copyWith(barChartTimePeriod: time);
  }

  void setBarChartStats(List<StatsModel> stats) {
    state = state.copyWith(barChartStats: stats);
  }

  void setTotalMeditationTime(int time) {
    state = state.copyWith(totalMeditationTime: time);
  }

  void setPageScrollOffset({required double offsetY, required Size size}) {
    if (offsetY / size.height > 0.50) {
      state = state.copyWith(drawLineChart: true);
    } else {
      state = state.copyWith(drawLineChart: false);
    }
  }
}

final chartStateProvider =
    StateNotifierProvider<ChartNotifier, ChartState>((ref) {
  return ChartNotifier(ChartState(
    totalMeditationTime: 0,
    toggleBarChart: false,
    barChartTimePeriod: TimePeriod.week,
    pageScrollOffset: 0,
    barChartStats: [],
    drawLineChart: false,
    lineChartHasBeenDrawn: false,
  ));
});

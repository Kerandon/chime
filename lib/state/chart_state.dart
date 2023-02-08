import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/time_period.dart';
import '../models/stats_model.dart';

class ChartState {
  final int totalMeditationTime;
  final bool toggleBarChart;
  final TimePeriod barChartTimePeriod;

  // final bool barChartHasData;
  final double pageScrollOffset;
  final List<StatsModel> barChartStats;
  final bool drawLineChart;

  ChartState({
    required this.totalMeditationTime,
    required this.toggleBarChart,
    required this.barChartTimePeriod,
    // required this.barChartHasData,
    required this.pageScrollOffset,
    required this.barChartStats,
    required this.drawLineChart,
  });

  ChartState copyWith({
    int? totalMeditationTime,
    bool? toggleBarChart,
    TimePeriod? barChartTimePeriod,
    // bool? barChartHasData,
    double? pageScrollOffset,
    List<StatsModel>? barChartStats,
    bool? drawLineChart,
  }) {
    return ChartState(
      totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
      toggleBarChart: toggleBarChart ?? this.toggleBarChart,
      barChartTimePeriod: barChartTimePeriod ?? this.barChartTimePeriod,
      // barChartHasData: barChartHasData ?? this.barChartHasData,
      pageScrollOffset: pageScrollOffset ?? this.pageScrollOffset,
      barChartStats: barChartStats ?? this.barChartStats,
      drawLineChart: drawLineChart ?? this.drawLineChart,
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

  void setTotalMeditationTime(int time) {
    state = state.copyWith(totalMeditationTime: time);
  }

  // void setChartsHaveData(bool haveData) {
  //   state = state.copyWith(barChartHasData: haveData);
  // }

  void setPageScrollOffset({required double offsetY, required Size size}) {
    if(offsetY / size.height > 0.50){
      state = state.copyWith(drawLineChart: true);
    }else{
      state = state.copyWith(drawLineChart: false);
    }
  }

  void setBarChartStats(List<StatsModel> stats) {
    state = state.copyWith(barChartStats: stats);
  }

  void setDrawLineChart(bool draw) {
    state = state.copyWith(drawLineChart: draw);
  }
}

final chartStateProvider =
    StateNotifierProvider<ChartNotifier, ChartState>((ref) {
  return ChartNotifier(ChartState(
    totalMeditationTime: 0,
    toggleBarChart: false,
    barChartTimePeriod: TimePeriod.week,
    // barChartHasData: false,
    pageScrollOffset: 0,
    barChartStats: [],
    drawLineChart: false,
  ));
});

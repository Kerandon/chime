import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/select.dart';
import '../enums/time_period.dart';
import '../models/stats_model.dart';

class ChartState {
  final int totalMeditationTime;
  final bool toggleBarChart;
  final TimePeriod barChartTimePeriod;
  final double pageScrollOffset;
  final List<StatsModel> barChartStats;
  final bool lineChartHasBeenDrawn;
  final bool linearChartHasAnimated;
  final Map<int, DateTime> selectedMeditationEvents;

  ChartState({
    required this.totalMeditationTime,
    required this.toggleBarChart,
    required this.barChartTimePeriod,
    required this.pageScrollOffset,
    required this.barChartStats,
    required this.lineChartHasBeenDrawn,
    required this.linearChartHasAnimated,
    required this.selectedMeditationEvents,
  });

  ChartState copyWith({
    int? totalMeditationTime,
    bool? toggleBarChart,
    TimePeriod? barChartTimePeriod,
    double? pageScrollOffset,
    List<StatsModel>? barChartStats,
    bool? lineChartHasBeenDrawn,
    bool? linearChartHasAnimated,
    Map<int, DateTime>? selectedMeditationEvents,
  }) {
    return ChartState(
      totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
      toggleBarChart: toggleBarChart ?? this.toggleBarChart,
      barChartTimePeriod: barChartTimePeriod ?? this.barChartTimePeriod,
      pageScrollOffset: pageScrollOffset ?? this.pageScrollOffset,
      barChartStats: barChartStats ?? this.barChartStats,
      lineChartHasBeenDrawn:
          lineChartHasBeenDrawn ?? this.lineChartHasBeenDrawn,
      linearChartHasAnimated:
          linearChartHasAnimated ?? this.linearChartHasAnimated,
      selectedMeditationEvents:
          selectedMeditationEvents ?? this.selectedMeditationEvents,
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
    state = state.copyWith(pageScrollOffset: offsetY);
  }

  void setLinearChartHasAnimated(bool hasAnimated) {
    state = state.copyWith(linearChartHasAnimated: hasAnimated);
  }

  void selectMeditationEvents({
    required Map<int, DateTime> items,
    bool unselect = false,
  }) {
    Map<int, DateTime> events = state.selectedMeditationEvents;

    for (int i = 0; i < items.length; i++) {
      final item = items.entries.elementAt(i);
      if (unselect == false) {
        events.addAll({item.key: item.value});
      } else {
        events.remove(item.key);
      }
    }

    state = state.copyWith(selectedMeditationEvents: events);
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
    lineChartHasBeenDrawn: false,
    linearChartHasAnimated: false,
    selectedMeditationEvents: {},
  ));
});

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/time_period.dart';

class ChartState {
  final int totalMeditationTime;
  final bool toggleBarChart;
  final TimePeriod barChartTimePeriod;
  final bool barChartHasData;

  ChartState({
    required this.totalMeditationTime,
    required this.toggleBarChart,
    required this.barChartTimePeriod,
    required this.barChartHasData,
  });

  ChartState copyWith(
      {int? totalMeditationTime,
      bool? toggleBarChart,
      TimePeriod? barChartTimePeriod,
      bool? barChartHasData}) {
    return ChartState(
        totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
        toggleBarChart: toggleBarChart ?? this.toggleBarChart,
        barChartTimePeriod: barChartTimePeriod ?? this.barChartTimePeriod,
        barChartHasData: barChartHasData ?? this.barChartHasData);
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

  void setChartsHaveData(bool haveData) {
    state = state.copyWith(barChartHasData: haveData);
  }
}

final chartStateProvider =
    StateNotifierProvider<ChartNotifier, ChartState>((ref) {
  return ChartNotifier(ChartState(
      totalMeditationTime: 0,
      toggleBarChart: false,
      barChartTimePeriod: TimePeriod.week,
      barChartHasData: false,
  ));
});

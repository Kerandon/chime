import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartState {
  final int totalMeditationTime;

  ChartState({required this.totalMeditationTime});

  ChartState copyWith({int? totalMeditationTime}) {
    return ChartState(
        totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime);
  }
}

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier(state) : super(state);
}

final chartStateProvider =
    StateNotifierProvider<ChartNotifier, ChartState>((ref) {
  return ChartNotifier(ChartState(totalMeditationTime: 0));
});

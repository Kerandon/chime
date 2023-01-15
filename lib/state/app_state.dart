import 'package:chime/enums/session_state.dart';
import 'package:chime/state/preferences_manager.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/ambience.dart';
import '../enums/focus_state.dart';
import '../enums/sounds.dart';

class AppState {
  final int totalTimeMinutes;
  final Set<int> intervalTimesMinutes;
  final int intervalTimeMinutes;
  final Sounds soundSelected;
  final SessionState sessionState;
  final FocusState focusState;
  final bool initialTimeIsSet;
  final int secondsRemaining;
  final int pausedTime;
  final bool sessionHasStarted;
  final bool checkIfStatsUpdated;
  final Ambience ambienceSelected;

  AppState({
    required this.totalTimeMinutes,
    required this.intervalTimesMinutes,
    required this.intervalTimeMinutes,
    required this.soundSelected,
    required this.sessionState,
    required this.focusState,
    required this.initialTimeIsSet,
    required this.secondsRemaining,
    required this.pausedTime,
    required this.sessionHasStarted,
    required this.checkIfStatsUpdated,
    required this.ambienceSelected,
  });

  AppState copyWith({
    int? totalTimeMinutes,
    Set<int>? intervalTimesMinutes,
    int? intervalTimeMinutes,
    Sounds? soundSelected,
    SessionState? sessionState,
    FocusState? focusState,
    bool? initialTimeIsSet,
    int? secondsRemaining,
    int? pausedTime,
    bool? sessionHasStarted,
    bool? checkIfStatsUpdated,
    Ambience? ambienceSelected,
  }) {
    return AppState(
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      intervalTimesMinutes: intervalTimesMinutes ?? this.intervalTimesMinutes,
      intervalTimeMinutes: intervalTimeMinutes ?? this.intervalTimeMinutes,
      soundSelected: soundSelected ?? this.soundSelected,
      sessionState: sessionState ?? this.sessionState,
      focusState: focusState ?? this.focusState,
      initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      pausedTime: pausedTime ?? this.pausedTime,
      sessionHasStarted: sessionHasStarted ?? this.sessionHasStarted,
      checkIfStatsUpdated: checkIfStatsUpdated ?? this.checkIfStatsUpdated,
      ambienceSelected: ambienceSelected ?? this.ambienceSelected,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTotalTime(int time) async {
    state = state.copyWith(
        totalTimeMinutes: time, intervalTimesMinutes: calculateIntervals(time));
  }

  void isInitialTimeSet(bool set) {
    state = state.copyWith(initialTimeIsSet: set);
  }

  void incrementTotalTime() {
    if (state.totalTimeMinutes < 9999) {
      state = state.copyWith(totalTimeMinutes: state.totalTimeMinutes + 1);
      state =
          state.copyWith(intervalTimesMinutes: calculateIntervals(state.totalTimeMinutes));
    }
  }

  void decrementTotalTime() {
    if (state.totalTimeMinutes > 0) {
      state = state.copyWith(totalTimeMinutes: state.totalTimeMinutes - 1);
      state =
          state.copyWith(intervalTimesMinutes: calculateIntervals(state.totalTimeMinutes));
    }
  }

  void setIntervalTime(int time) async {
    await PreferencesManager.setPreferences(interval: time);
    state = state.copyWith(intervalTimeMinutes: time);
  }

  void setIntervalTimes(Set<int> times) {
    state = state.copyWith(intervalTimesMinutes: times);
  }

  void setSound(Sounds sound) async {
    await PreferencesManager.setPreferences(sound: sound);
    state = state.copyWith(soundSelected: sound);
  }

  void setSessionState(SessionState sessionState) async {
    state = state.copyWith(sessionState: sessionState);
    print('session state is ${sessionState}');
    if (sessionState == SessionState.ended) {
      await PreferencesManager.addToStreak(DateTime.now());
    }
  }

  void setSessionHasStarted(bool started) {
    state = state.copyWith(sessionHasStarted: started);
  }

  void resetSession() {
    state = state.copyWith(
      pausedTime: 0, sessionHasStarted: false, secondsRemaining: 0
    );
  }

  void setTimerFocusState(FocusState focus) {
    state = state.copyWith(focusState: focus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(focusState: FocusState.none);
    });
  }

  void setSecondsRemaining(int seconds) {
    state = state.copyWith(secondsRemaining: seconds);
  }

  void setPausedTime({bool? reset}) {
    int time = state.secondsRemaining;
    if (reset == true) {
      time = 0;
    }
    state = state.copyWith(pausedTime: time);
  }

  void checkIfStatsUpdated(bool check) {
    state = state.copyWith(checkIfStatsUpdated: check);
  }

  void selectAmbience(Ambience ambience){
    state = state.copyWith(ambienceSelected: ambience);
  }

}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    totalTimeMinutes: 60,
    intervalTimesMinutes: {1},
    intervalTimeMinutes: 1,
    soundSelected: Sounds.chime,
    sessionState: SessionState.notStarted,
    focusState: FocusState.none,
    initialTimeIsSet: false,
    secondsRemaining: 0,
    pausedTime: 0,
    sessionHasStarted: false,
    checkIfStatsUpdated: false,
    ambienceSelected: Ambience.none,
  ));
});

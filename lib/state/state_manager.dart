import 'package:chime/enums/session_status.dart';
import 'package:chime/state/preferences_manager.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/ambience.dart';
import '../enums/focus_state.dart';
import '../enums/sounds.dart';

class AppState {
  final int totalTime;
  final Set<int> intervalTimes;
  final int intervalTime;
  final Sounds soundSelected;
  final SessionStatus sessionStatus;
  final FocusState focusState;
  final bool initialTimeIsSet;
  final int secondsRemaining;
  final int milliSecondsElapsed;
  final int pausedTime;
  final bool sessionHasStarted;
  final bool checkIfStatsUpdated;
  final Ambience ambienceSelected;

  AppState({
    required this.totalTime,
    required this.intervalTimes,
    required this.intervalTime,
    required this.soundSelected,
    required this.sessionStatus,
    required this.focusState,
    required this.initialTimeIsSet,
    required this.secondsRemaining,
    required this.milliSecondsElapsed,
    required this.pausedTime,
    required this.sessionHasStarted,
    required this.checkIfStatsUpdated,
    required this.ambienceSelected,
  });

  AppState copyWith({
    int? totalTime,
    Set<int>? intervalTimes,
    int? intervalTime,
    Sounds? soundSelected,
    SessionStatus? sessionStatus,
    FocusState? focusState,
    bool? initialTimeIsSet,
    bool? sessionInProgress,
    int? secondsRemaining,
    int? milliSecondsElapsed,
    int? pausedTime,
    bool? sessionHasStarted,
    bool? appHasLoaded,
    bool? checkIfStatsUpdated,
    Ambience? ambienceSelected,
  }) {
    return AppState(
      totalTime: totalTime ?? this.totalTime,
      intervalTimes: intervalTimes ?? this.intervalTimes,
      intervalTime: intervalTime ?? this.intervalTime,
      soundSelected: soundSelected ?? this.soundSelected,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      focusState: focusState ?? this.focusState,
      initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      pausedTime: pausedTime ?? this.pausedTime,
      sessionHasStarted: sessionHasStarted ?? this.sessionHasStarted,
      checkIfStatsUpdated: appHasLoaded ?? this.checkIfStatsUpdated,
      milliSecondsElapsed: milliSecondsElapsed ?? this.milliSecondsElapsed,
      ambienceSelected: ambienceSelected ?? this.ambienceSelected,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTotalTime(int time) async {
    state = state.copyWith(
        totalTime: time, intervalTimes: calculateIntervals(time));
  }

  void isInitialTimeSet(bool set) {
    state = state.copyWith(initialTimeIsSet: set);
  }

  void incrementTotalTime() {
    if (state.totalTime < 9999) {
      state = state.copyWith(totalTime: state.totalTime + 1);
      state =
          state.copyWith(intervalTimes: calculateIntervals(state.totalTime));
    }
  }

  void decrementTotalTime() {
    if (state.totalTime > 0) {
      state = state.copyWith(totalTime: state.totalTime - 1);
      state =
          state.copyWith(intervalTimes: calculateIntervals(state.totalTime));
    }
  }

  void setIntervalTime(int time) async {
    await PreferencesManager.setPreferences(interval: time);
    state = state.copyWith(intervalTime: time);
  }

  void setIntervalTimes(Set<int> times) {
    state = state.copyWith(intervalTimes: times);
  }

  void setSound(Sounds sound) async {
    await PreferencesManager.setPreferences(sound: sound);
    state = state.copyWith(soundSelected: sound);
  }

  void setSessionStatus(SessionStatus status) async {
    state = state.copyWith(sessionStatus: status);
    if (status == SessionStatus.ended) {
      await PreferencesManager.addToStreak(DateTime.now());
    }
  }

  void setSessionHasStarted(bool started) {
    state = state.copyWith(sessionHasStarted: started);
  }

  void resetSession() {
    state = state.copyWith(
      pausedTime: 0,
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

  void setMillisecondsElapsed(int milliseconds) {
    state = state.copyWith(milliSecondsElapsed: milliseconds);
  }

  void setPausedTime({bool? reset}) {
    int time = state.secondsRemaining;
    if (reset == true) {
      time = 0;
    }
    state = state.copyWith(pausedTime: time);
  }

  void checkIfStatsUpdated(bool check) {
    state = state.copyWith(appHasLoaded: check);
  }

  void selectAmbience(Ambience ambience){
    state = state.copyWith(ambienceSelected: ambience);
  }

}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    totalTime: 60,
    intervalTimes: {1},
    intervalTime: 1,
    soundSelected: Sounds.chime,
    sessionStatus: SessionStatus.notStarted,
    focusState: FocusState.none,
    initialTimeIsSet: false,
    secondsRemaining: 0,
    pausedTime: 0,
    sessionHasStarted: false,
    checkIfStatsUpdated: false,
    milliSecondsElapsed: 0,
    ambienceSelected: Ambience.none,
  ));
});

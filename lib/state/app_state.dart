import 'package:chime/enums/session_state.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:chime/state/preferences_streak.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../audio/audio_manager.dart';
import '../enums/ambience.dart';
import '../enums/focus_state.dart';
import '../enums/sounds.dart';
import '../utils/methods.dart';

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
  final double ambienceVolume;
  final Set<int> bellTimes;

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
    required this.ambienceVolume,
    required this.bellTimes,
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
    double? ambienceVolume,
    Set<int>? bellTimes,
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
      ambienceVolume: ambienceVolume ?? this.ambienceVolume,
      bellTimes: bellTimes ?? this.bellTimes,
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
      state = state.copyWith(
          intervalTimesMinutes: calculateIntervals(state.totalTimeMinutes));
    }
  }

  void decrementTotalTime() {
    if (state.totalTimeMinutes > 0) {
      state = state.copyWith(totalTimeMinutes: state.totalTimeMinutes - 1);
      state = state.copyWith(
          intervalTimesMinutes: calculateIntervals(state.totalTimeMinutes));
    }
  }

  void setIntervalTime(int time) async {
    await PreferencesMain.setPreferences(interval: time);
    state = state.copyWith(intervalTimeMinutes: time);
    _calculateBellIntervalsAndTimes();
  }

  void setIntervalTimes(Set<int> times) {
    state = state.copyWith(intervalTimesMinutes: times);
  }

  void setSound(Sounds sound) async {
    await PreferencesMain.setPreferences(sound: sound);
    state = state.copyWith(soundSelected: sound);
  }

  void setSessionState(SessionState sessionState) async {
    print('session state is $sessionState');

    state = state.copyWith(sessionState: sessionState);

    if (sessionState == SessionState.notStarted) {
      AudioManager().stopAmbienceAudio();
    } else if (sessionState == SessionState.countdown) {
      await AudioManager().playAmbience(state.ambienceSelected);
    } else if (sessionState == SessionState.inProgress) {
      await AudioManager().resumeAmbience();
    } else if (sessionState == SessionState.paused) {
      await AudioManager().pauseAmbience();
    } else if (sessionState == SessionState.ended) {
      await PreferencesStreak.addToStreak(DateTime.now());
      AudioManager().stopAmbienceAudio();
    }
  }

  void setSessionHasStarted(bool started) {
    state = state.copyWith(sessionHasStarted: started);
  }

  void resetSession() {
    state = state.copyWith(
        pausedTime: 0, sessionHasStarted: false, secondsRemaining: 0);
  }

  void setTimerFocusState(FocusState focus) {
    state = state.copyWith(focusState: focus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(focusState: FocusState.none);
    });
  }

  void setSecondsRemaining(int seconds) {
    state = state.copyWith(secondsRemaining: seconds);
    playSessionBells(state);
  }

  void _calculateBellIntervalsAndTimes() {
    if (state.intervalTimeMinutes == 0) {
      return;
    }
    Set<int> bellTimes = {};
    int numberOfSounds = state.totalTimeMinutes ~/ state.intervalTimeMinutes;
    for (int i = 0; i < numberOfSounds; i++) {
      int bellTime = state.totalTimeMinutes - (state.intervalTimeMinutes * i);
      bellTimes.add(bellTime);
    }
    state = state.copyWith(bellTimes: bellTimes);
    for (var i in bellTimes) {
      // print('bell times are $i');
    }
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

  void setAmbience(Ambience ambience) async {
    state = state.copyWith(ambienceSelected: ambience);
    if (ambience == Ambience.none) {
      await AudioManager().stopAmbienceAudio();
    }
  }

  void setAmbienceVolume(double volume) {
    state = state.copyWith(ambienceVolume: volume);
    AudioManager().setAmbienceVolume(state.ambienceVolume);
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
    ambienceVolume: 0.50,
    bellTimes: {},
  ));
});

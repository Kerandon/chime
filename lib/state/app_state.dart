import 'package:chime/enums/session_state.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:chime/state/preferences_streak.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../audio/audio_manager.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/focus_state.dart';
import '../utils/methods.dart';

class AppState {
  //APP STATE
  final SessionState sessionState;
  final bool sessionHasStarted;
  final FocusState focusState;

  //TIME
  final int totalTimeMinutes;
  final bool initialTimeIsSet;
  final int secondsRemaining;
  final int pausedTime;

  //BELLS
  final Set<int> bellIntervalMenuSelection;
  final Bell bellSelected;
  final int bellIntervalTimeSelected;
  final Set<int> bellTimesToRing;
  final double bellVolume;

  //AMBIENCE
  final Ambience ambienceSelected;
  final double ambienceVolume;

  //STATS
  final bool checkIfStatsUpdated;

  AppState({
    required this.sessionState,
    required this.sessionHasStarted,
    required this.focusState,
    required this.totalTimeMinutes,
    required this.initialTimeIsSet,
    required this.secondsRemaining,
    required this.pausedTime,
    required this.bellIntervalMenuSelection,
    required this.bellSelected,
    required this.bellIntervalTimeSelected,
    required this.bellTimesToRing,
    required this.bellVolume,
    required this.ambienceSelected,
    required this.ambienceVolume,
    required this.checkIfStatsUpdated,
  });

  AppState copyWith({
    SessionState? sessionState,
    bool? sessionHasStarted,
    FocusState? focusState,
    int? totalTimeMinutes,
    bool? initialTimeIsSet,
    int? secondsRemaining,
    int? pausedTime,
    Set<int>? bellIntervalMenuSelection,
    Bell? bellSelected,
    int? bellIntervalTimeSelected,
    Set<int>? bellTimesToRing,
    double? bellVolume,
    Ambience? ambienceSelected,
    double? ambienceVolume,
    bool? checkIfStatsUpdated,
  }) {
    return AppState(
      sessionState: sessionState ?? this.sessionState,
      sessionHasStarted: sessionHasStarted ?? this.sessionHasStarted,
      focusState: focusState ?? this.focusState,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      pausedTime: pausedTime ?? this.pausedTime,
      bellIntervalMenuSelection:
          bellIntervalMenuSelection ?? this.bellIntervalMenuSelection,
      bellSelected: bellSelected ?? this.bellSelected,
      bellIntervalTimeSelected:
          bellIntervalTimeSelected ?? this.bellIntervalTimeSelected,
      bellTimesToRing: bellTimesToRing ?? this.bellTimesToRing,
      bellVolume: bellVolume ?? this.bellVolume,
      ambienceSelected: ambienceSelected ?? this.ambienceSelected,
      ambienceVolume: ambienceVolume ?? this.ambienceVolume,
      checkIfStatsUpdated: checkIfStatsUpdated ?? this.checkIfStatsUpdated,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTotalTime(int time) async {
    state = state.copyWith(
        totalTimeMinutes: time,
        bellIntervalMenuSelection: calculateIntervals(time));
  }

  void isInitialTimeSet(bool set) {
    state = state.copyWith(initialTimeIsSet: set);
  }

  void incrementTotalTime() {
    if (state.totalTimeMinutes < 9999) {
      state = state.copyWith(totalTimeMinutes: state.totalTimeMinutes + 1);
      state = state.copyWith(
          bellIntervalMenuSelection:
              calculateIntervals(state.totalTimeMinutes));
    }
  }

  void decrementTotalTime() {
    if (state.totalTimeMinutes > 0) {
      state = state.copyWith(totalTimeMinutes: state.totalTimeMinutes - 1);
      state = state.copyWith(
          bellIntervalMenuSelection:
              calculateIntervals(state.totalTimeMinutes));
    }
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

  void setPausedTime({bool? reset}) {
    int time = state.secondsRemaining;
    if (reset == true) {
      time = 0;
    }
    state = state.copyWith(pausedTime: time);
  }

  void setBellMenuSelection(Set<int> times) {
    state = state.copyWith(bellIntervalMenuSelection: times);
  }

  void _calculateBellIntervalsAndTimes() {
    if (state.bellIntervalTimeSelected == 0) {
      return;
    }
    Set<int> bellTimes = {};
    int numberOfSounds =
        state.totalTimeMinutes ~/ state.bellIntervalTimeSelected;
    for (int i = 0; i < numberOfSounds; i++) {
      int bellTime =
          state.totalTimeMinutes - (state.bellIntervalTimeSelected * i);
      bellTimes.add(bellTime);
    }
    state = state.copyWith(bellTimesToRing: bellTimes);
  }

  void setBellIntervalTime(int time) async {
    await PreferencesMain.setPreferences(bellInterval: time);
    state = state.copyWith(bellIntervalTimeSelected: time);
    _calculateBellIntervalsAndTimes();
  }

  void setBellSelected(Bell bell) async {
    await PreferencesMain.setPreferences(bellSelected: bell);
    state = state.copyWith(bellSelected: bell);
  }

  void setBellVolume(double volume) async {
    await PreferencesMain.setPreferences(bellVolume: volume);
    state = state.copyWith(bellVolume: volume);
    print('bell volume is set to ${state.bellVolume}');
    await AudioManager().setBellVolume(volume);
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

  void checkIfStatsUpdated(bool check) {
    state = state.copyWith(checkIfStatsUpdated: check);
  }
}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    sessionState: SessionState.notStarted,
    sessionHasStarted: false,
    focusState: FocusState.none,
    totalTimeMinutes: 60,
    initialTimeIsSet: false,
    secondsRemaining: 0,
    pausedTime: 0,
    bellIntervalMenuSelection: {1},
    bellSelected: Bell.chime,
    bellIntervalTimeSelected: 1,
    bellTimesToRing: {},
    bellVolume: 0.50,
    ambienceSelected: Ambience.none,
    ambienceVolume: 0.50,
    checkIfStatsUpdated: false,
  ));
});

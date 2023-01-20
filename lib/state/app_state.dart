import 'package:chime/configs/constants.dart';
import 'package:chime/enums/audio_type.dart';
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
  final bool longTapInProgress;

  //TIME
  final int totalTimeMinutes;
  final bool initialTimeIsSet;
  final int millisecondsRemaining;
  final int pausedMillisecondsRemaining;
  final int totalCountdownTime;
  final int currentCountdownTime;

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
    required this.longTapInProgress,
    required this.totalTimeMinutes,
    required this.initialTimeIsSet,
    required this.millisecondsRemaining,
    required this.pausedMillisecondsRemaining,
    required this.totalCountdownTime,
    required this.currentCountdownTime,
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
    bool? longTapInProgress,
    int? totalTimeMinutes,
    bool? initialTimeIsSet,
    int? millisecondsRemaining,
    int? pausedMillisecondsRemaining,
    int? totalCountdownTime,
    int? currentCountdownTime,
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
      longTapInProgress: longTapInProgress ?? this.longTapInProgress,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
      millisecondsRemaining:
          millisecondsRemaining ?? this.millisecondsRemaining,
      pausedMillisecondsRemaining:
          pausedMillisecondsRemaining ?? this.pausedMillisecondsRemaining,
      totalCountdownTime: totalCountdownTime ?? this.totalCountdownTime,
      currentCountdownTime: currentCountdownTime ?? this.currentCountdownTime,
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
    if (state.totalTimeMinutes > 1) {
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
      AudioManager().stop(audioType: AudioType.ambience);
    } else if (sessionState == SessionState.countdown) {
      await AudioManager().playAmbience(
          ambience: state.ambienceSelected,
          fadeInMilliseconds: kAudioFadeDuration * 2);
    } else if (sessionState == SessionState.inProgress) {
      await AudioManager().resumeAmbience();
    } else if (sessionState == SessionState.paused) {
      await AudioManager().pauseAmbience();
    } else if (sessionState == SessionState.ended) {
      await PreferencesStreak.addToStreak(DateTime.now());
    }
  }

  void setSessionHasStarted(bool started) {
    state = state.copyWith(sessionHasStarted: started);
  }

  void resetSession() {
    state = state.copyWith(
        pausedMillisecondsRemaining: 0,
        sessionHasStarted: false,
        millisecondsRemaining: 0);
  }

  void setLongTapInProgress(bool inProgress) {
    state = state.copyWith(longTapInProgress: inProgress);
  }

  void setTimerFocusState(FocusState focus) {
    state = state.copyWith(focusState: focus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(focusState: FocusState.none);
    });
  }

  void seMillisecondsRemaining(int milliseconds) {
    state = state.copyWith(millisecondsRemaining: milliseconds);
    playSessionBells(state);
  }

  void setPausedTimeMillisecondsRemaining({bool? reset}) {
    int? time;
    if (reset == true) {
      time = 0;
    } else {
      time = state.millisecondsRemaining;
    }
    print('time paused is $time');
    state = state.copyWith(pausedMillisecondsRemaining: time);
  }

  void setTotalCountdownTime(int time) {
    state = state.copyWith(totalCountdownTime: time);
  }

  void setCurrentCountdownTime(int time) {
    state = state.copyWith(currentCountdownTime: time);
  }

  void setBellMenuSelection(Set<int> times) {
    state = state.copyWith(bellIntervalMenuSelection: times);
  }

  void setBellIntervalTime(int time) async {
    await PreferencesMain.setPreferences(bellInterval: time);
    state = state.copyWith(bellIntervalTimeSelected: time);
    _calculateBellIntervalsAndTimes();
  }

  void _calculateBellIntervalsAndTimes() {
    print('calculating bell times');
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

    for (var b in state.bellTimesToRing) {
      print(b);
    }

    state = state.copyWith(bellTimesToRing: bellTimes);
  }

  void setBellSelected(Bell bell) async {
    await PreferencesMain.setPreferences(bellSelected: bell);
    state = state.copyWith(bellSelected: bell);
  }

  void setAmbienceSelected(Ambience ambience) async {
    state = state.copyWith(ambienceSelected: ambience);
    if (ambience == Ambience.none) {
      await AudioManager().stop(audioType: AudioType.ambience);
    }
  }

  void setBellVolume(double volume) {
    state = state.copyWith(ambienceVolume: volume);
    AudioManager().setVolume(audioType: AudioType.bells, volume: volume);
  }

  void setAmbienceVolume(double volume) {
    state = state.copyWith(ambienceVolume: volume);
    AudioManager().setVolume(audioType: AudioType.ambience, volume: volume);
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
    longTapInProgress: false,
    totalTimeMinutes: 60,
    initialTimeIsSet: false,
    millisecondsRemaining: 0,
    pausedMillisecondsRemaining: 0,
    currentCountdownTime: 5,
    totalCountdownTime: 6,
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

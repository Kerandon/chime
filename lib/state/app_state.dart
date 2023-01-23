import 'package:chime/configs/constants.dart';
import 'package:chime/database_manager.dart';
import 'package:chime/enums/audio_type.dart';
import 'package:chime/enums/color_themes.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../audio/audio_manager.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/focus_state.dart';
import '../enums/prefs.dart';
import '../utils/methods.dart';

class AppState {
  //APP STATE
  final SessionState sessionState;
  final bool sessionHasStarted;
  final FocusState focusState;
  final bool longTapInProgress;
  final ColorTheme colorTheme;

  //TIME
  final int totalTimeMinutes;
  final bool initialTimeIsSet;
  final int millisecondsRemaining;
  final int pausedMillisecondsRemaining;
  final int totalCountdownTime;
  final int currentCountdownTime;
  final bool openSession;

  //BELLS
  final Set<int> bellIntervalMenuSelection;
  final Bell bellSelected;
  final int bellIntervalTimeSelected;
  final Set<int> bellTimesToRing;
  final double bellVolume;
  final bool bellOnSessionStart;

  //AMBIENCE
  final Ambience ambienceSelected;
  final double ambienceVolume;

  //STATS
  final bool checkIfStatsUpdated;

  //Layout
  final bool hideClock;

  AppState({
    required this.sessionState,
    required this.sessionHasStarted,
    required this.focusState,
    required this.longTapInProgress,
    required this.colorTheme,
    required this.totalTimeMinutes,
    required this.initialTimeIsSet,
    required this.millisecondsRemaining,
    required this.pausedMillisecondsRemaining,
    required this.totalCountdownTime,
    required this.currentCountdownTime,
    required this.openSession,
    required this.bellIntervalMenuSelection,
    required this.bellSelected,
    required this.bellIntervalTimeSelected,
    required this.bellTimesToRing,
    required this.bellVolume,
    required this.bellOnSessionStart,
    required this.ambienceSelected,
    required this.ambienceVolume,
    required this.checkIfStatsUpdated,
    required this.hideClock,
  });

  AppState copyWith({
    SessionState? sessionState,
    bool? sessionHasStarted,
    FocusState? focusState,
    ColorTheme? colorTheme,
    bool? longTapInProgress,
    int? totalTimeMinutes,
    bool? initialTimeIsSet,
    int? millisecondsRemaining,
    int? pausedMillisecondsRemaining,
    int? totalCountdownTime,
    int? currentCountdownTime,
    bool? openSession,
    Set<int>? bellIntervalMenuSelection,
    Bell? bellSelected,
    int? bellIntervalTimeSelected,
    Set<int>? bellTimesToRing,
    double? bellVolume,
    bool? bellOnSessionStart,
    Ambience? ambienceSelected,
    double? ambienceVolume,
    bool? checkIfStatsUpdated,
    bool? hideClock,
  }) {
    return AppState(
      sessionState: sessionState ?? this.sessionState,
      sessionHasStarted: sessionHasStarted ?? this.sessionHasStarted,
      focusState: focusState ?? this.focusState,
      longTapInProgress: longTapInProgress ?? this.longTapInProgress,
      colorTheme: colorTheme ?? this.colorTheme,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
      millisecondsRemaining:
          millisecondsRemaining ?? this.millisecondsRemaining,
      pausedMillisecondsRemaining:
          pausedMillisecondsRemaining ?? this.pausedMillisecondsRemaining,
      totalCountdownTime: totalCountdownTime ?? this.totalCountdownTime,
      currentCountdownTime: currentCountdownTime ?? this.currentCountdownTime,
      openSession: openSession ?? this.openSession,
      bellIntervalMenuSelection:
          bellIntervalMenuSelection ?? this.bellIntervalMenuSelection,
      bellSelected: bellSelected ?? this.bellSelected,
      bellIntervalTimeSelected:
          bellIntervalTimeSelected ?? this.bellIntervalTimeSelected,
      bellTimesToRing: bellTimesToRing ?? this.bellTimesToRing,
      bellVolume: bellVolume ?? this.bellVolume,
      bellOnSessionStart: bellOnSessionStart ?? this.bellOnSessionStart,
      ambienceSelected: ambienceSelected ?? this.ambienceSelected,
      ambienceVolume: ambienceVolume ?? this.ambienceVolume,
      checkIfStatsUpdated: checkIfStatsUpdated ?? this.checkIfStatsUpdated,
      hideClock: hideClock ?? this.hideClock,
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
      //todo add streak
      // await PreferencesStreak.addToStreak(DateTime.now());
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

  void setColorTheme(ColorTheme colorTheme) {
    state = state.copyWith(colorTheme: colorTheme);
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
    state = state.copyWith(pausedMillisecondsRemaining: time);
  }

  void setTotalCountdownTime(int time) {
    state = state.copyWith(totalCountdownTime: time);
  }

  void setCurrentCountdownTime(int time) {
    state = state.copyWith(currentCountdownTime: time);
  }

  void setOpenSession(bool open) {
    state = state.copyWith(openSession: open);
  }

  void setBellMenuSelection(Set<int> times) {
    state = state.copyWith(bellIntervalMenuSelection: times);
  }

  void setBellIntervalTime(int time) async {
    await DatabaseManager().insertIntoPrefs(k: Prefs.bellInterval.name, v: time);
    state = state.copyWith(bellIntervalTimeSelected: time);
    _calculateBellIntervalsAndTimes();
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

  void setBellSelected(Bell bell) async {
    //await DatabaseManager().insertIntoPrefs(k: Prefs.bellSelected.name, v: bell);
    state = state.copyWith(bellSelected: bell);
  }

  void setBellOnSessionStart(bool onStart) {
    state = state.copyWith(bellOnSessionStart: onStart);
  }

  void setAmbienceSelected(Ambience ambience) async {
    print('ambience received notify is $ambience');
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

  void setHideClock(bool hide){
    state = state.copyWith(hideClock: hide);
  }
}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    sessionState: SessionState.notStarted,
    sessionHasStarted: false,
    focusState: FocusState.none,
    longTapInProgress: false,
    colorTheme: ColorTheme.darkTeal,
    totalTimeMinutes: 60,
    initialTimeIsSet: false,
    millisecondsRemaining: 0,
    pausedMillisecondsRemaining: 0,
    currentCountdownTime: 5,
    totalCountdownTime: 6,
    openSession: false,
    bellIntervalMenuSelection: {1},
    bellSelected: Bell.chime,
    bellIntervalTimeSelected: 1,
    bellTimesToRing: {},
    bellVolume: 0.50,
    bellOnSessionStart: true,
    ambienceSelected: Ambience.none,
    ambienceVolume: 0.50,
    checkIfStatsUpdated: false,
    hideClock: false,
  ));
});

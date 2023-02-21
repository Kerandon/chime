import 'package:chime/state/database_manager.dart';
import 'package:chime/enums/app_color_themes.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/utils/calculate_intervals.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/focus_state.dart';
import '../enums/prefs.dart';
import '../utils/vibration_method.dart';

class AppState {
  //APP STATE
  final SessionState sessionState;
  //final bool sessionHasStarted;

  //final bool sessionStopped;
  final int currentPage;

  //TIME
  final int totalTimeMinutes;
  final bool initialTimeIsSet;
  final int millisecondsRemaining;
  final int millisecondsElapsed;
  final int pausedMilliseconds;
  final bool countdownIsOn;
  final int totalCountdownTime;
  final int currentCountdownTime;
  final bool openSession;

  //BELLS
  final Set<int> bellIntervalMenuSelection;
  final Bell bellSelected;
  final int selectedIntervalBellTime;
  final Set<int> bellTimesToRing;
  final double bellVolume;
  final bool bellOnSessionStart;
  final bool bellOnSessionEnd;

  //AMBIENCE
  final bool ambienceIsOn;
  final Ambience ambienceSelected;
  final double ambienceVolume;

  //VIBRATE
  final bool vibrateOnCompletion;

  //MUTE
  final bool deviceIsMuted;

  //STATS
  final bool checkIfStatsUpdated;

  //THEME
  final AppColorTheme colorTheme;
  final bool isDarkTheme;

  //LAYOUT
  final bool hideClock;

  //SPLASH
  final bool animateSplash;

  AppState({
    required this.sessionState,
    //required this.sessionHasStarted,
    //required this.sessionStopped,
    required this.currentPage,
    required this.totalTimeMinutes,
    required this.initialTimeIsSet,
    required this.millisecondsRemaining,
    required this.millisecondsElapsed,
    required this.pausedMilliseconds,
    required this.countdownIsOn,
    required this.totalCountdownTime,
    required this.currentCountdownTime,
    required this.openSession,
    required this.bellIntervalMenuSelection,
    required this.bellSelected,
    required this.selectedIntervalBellTime,
    required this.bellTimesToRing,
    required this.bellVolume,
    required this.bellOnSessionStart,
    required this.bellOnSessionEnd,
    required this.ambienceIsOn,
    required this.ambienceSelected,
    required this.ambienceVolume,
    required this.vibrateOnCompletion,
    required this.deviceIsMuted,
    required this.checkIfStatsUpdated,
    required this.colorTheme,
    required this.isDarkTheme,
    required this.hideClock,
    required this.animateSplash,
  });

  AppState copyWith({
    SessionState? sessionState,
    //bool? sessionHasStarted,
    FocusState? focusState,
    int? currentPage,
    //bool? sessionStopped,
    int? totalTimeMinutes,
    bool? initialTimeIsSet,
    int? millisecondsRemaining,
    int? millisecondsElapsed,
    int? pausedMilliseconds,
    bool? countdownIsOn,
    int? totalCountdownTime,
    int? currentCountdownTime,
    bool? openSession,
    Set<int>? bellIntervalMenuSelection,
    Bell? bellSelected,
    int? bellIntervalTimeSelected,
    Set<int>? bellTimesToRing,
    double? bellVolume,
    bool? bellOnSessionStart,
    bool? bellOnSessionEnd,
    bool? ambienceIsOn,
    Ambience? ambienceSelected,
    double? ambienceVolume,
    bool? vibrateOnCompletion,
    bool? deviceIsMuted,
    bool? checkIfStatsUpdated,
    AppColorTheme? colorTheme,
    bool? isDarkTheme,
    bool? hideClock,
    bool? animateSplash,
  }) {
    return AppState(
        sessionState: sessionState ?? this.sessionState,
        //sessionHasStarted: sessionHasStarted ?? this.sessionHasStarted,
        //sessionStopped: sessionStopped ?? this.sessionStopped,
        currentPage: currentPage ?? this.currentPage,
        totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
        initialTimeIsSet: initialTimeIsSet ?? this.initialTimeIsSet,
        millisecondsRemaining:
            millisecondsRemaining ?? this.millisecondsRemaining,
        millisecondsElapsed: millisecondsElapsed ?? this.millisecondsElapsed,
        pausedMilliseconds: pausedMilliseconds ?? this.pausedMilliseconds,
        countdownIsOn: countdownIsOn ?? this.countdownIsOn,
        totalCountdownTime: totalCountdownTime ?? this.totalCountdownTime,
        currentCountdownTime: currentCountdownTime ?? this.currentCountdownTime,
        openSession: openSession ?? this.openSession,
        bellIntervalMenuSelection:
            bellIntervalMenuSelection ?? this.bellIntervalMenuSelection,
        bellSelected: bellSelected ?? this.bellSelected,
        selectedIntervalBellTime:
            bellIntervalTimeSelected ?? selectedIntervalBellTime,
        bellTimesToRing: bellTimesToRing ?? this.bellTimesToRing,
        bellVolume: bellVolume ?? this.bellVolume,
        bellOnSessionStart: bellOnSessionStart ?? this.bellOnSessionStart,
        bellOnSessionEnd: bellOnSessionEnd ?? this.bellOnSessionEnd,
        ambienceIsOn: ambienceIsOn ?? this.ambienceIsOn,
        ambienceSelected: ambienceSelected ?? this.ambienceSelected,
        ambienceVolume: ambienceVolume ?? this.ambienceVolume,
        vibrateOnCompletion: vibrateOnCompletion ?? this.vibrateOnCompletion,
        deviceIsMuted: deviceIsMuted ?? this.deviceIsMuted,
        checkIfStatsUpdated: checkIfStatsUpdated ?? this.checkIfStatsUpdated,
        colorTheme: colorTheme ?? this.colorTheme,
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        hideClock: hideClock ?? this.hideClock,
        animateSplash: animateSplash ?? this.animateSplash);
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTotalTime({int? minutes, int? hours, bool afterRestart = false}) {
    int updatedTotalTime = 0;
    int currentTimeMinutes = state.totalTimeMinutes % 60;
    int currentTimeHours = state.totalTimeMinutes ~/ 60;
    updatedTotalTime = 0;
    if (minutes != null) {
      updatedTotalTime = (currentTimeHours * 60) + minutes;
    }
    if (hours != null) {
      updatedTotalTime = currentTimeMinutes + (hours * 60);
    }
    Set<int> intervals = calculateIntervals(
        totalTime: updatedTotalTime, openSession: state.openSession);

    state = state.copyWith(
        totalTimeMinutes: updatedTotalTime,
        bellIntervalMenuSelection: intervals);

    DatabaseManager()
        .insertIntoPrefs(k: Prefs.timeTotal.name, v: updatedTotalTime);
  }

  void setTotalTimeAfterRestart(int total) {
    Set<int> intervals =
        calculateIntervals(totalTime: total, openSession: state.openSession);
    state = state.copyWith(
        totalTimeMinutes: total, bellIntervalMenuSelection: intervals);
  }

  void isInitialTimeSet(bool set) {
    state = state.copyWith(initialTimeIsSet: set);
  }

  void setSessionState(SessionState sessionState) async {
    state = state.copyWith(sessionState: sessionState);

    if (sessionState == SessionState.notStarted) {
    } else if (sessionState == SessionState.countdown) {
    } else if (sessionState == SessionState.inProgress) {
    } else if (sessionState == SessionState.paused) {
    } else if (sessionState == SessionState.ended) {
      if (state.vibrateOnCompletion) {
        await vibrateDevice();
      }
      //todo add streak
    }
  }


  void resetSession() {
    state = state.copyWith(
      initialTimeIsSet: false,
      pausedMilliseconds: 0,
      currentCountdownTime: 0,
      millisecondsRemaining: 0,
      millisecondsElapsed: 0,

    );
    // final int totalTimeMinutes;
    // final bool initialTimeIsSet;
    // final int millisecondsRemaining;
    // final int millisecondsElapsed;
    // final int pausedMilliseconds;
    // final bool countdownIsOn;
    // final int totalCountdownTime;
    // final int currentCountdownTime;
    // final bool openSession;
  }

  void setPage(int index) {
    state = state.copyWith(currentPage: index);
  }

  void setMillisecondsRemaining(int milliseconds) {
    state = state.copyWith(millisecondsRemaining: milliseconds);
  }

  void setMillisecondsElapsed(int milliseconds) {
    state = state.copyWith(millisecondsElapsed: milliseconds);
  }

  void setPausedTimeMilliseconds({bool? reset}) {
    int? time;
    if (reset == true) {
      time = 0;
    } else {
      if (state.openSession) {
        time = state.millisecondsElapsed;
      } else {
        time = state.millisecondsRemaining;
      }
    }

    state = state.copyWith(pausedMilliseconds: time);
  }

  void setCountdownIsOn(bool on) {
    state = state.copyWith(countdownIsOn: on);
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

  void setBellIntervalTime(int time) async {
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellInterval.name, v: time);
    state = state.copyWith(bellIntervalTimeSelected: time);
    _calculateBellIntervalsAndTimes();
  }

  void _calculateBellIntervalsAndTimes() {
    if (state.selectedIntervalBellTime == 0) {
      return;
    }
    List<int> possibleBellTimes = [1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 60];

    final bellTimes =
        possibleBellTimes.takeWhile((value) => value < state.totalTimeMinutes);

    // int numberOfSounds =
    //     state.totalTimeMinutes ~/ state.selectedIntervalBellTime;
    // for (int i = 0; i < numberOfSounds; i++) {
    //   int bellTime =
    //       state.totalTimeMinutes - (state.selectedIntervalBellTime * i);
    //   bellTimes.add(bellTime);
    // }
    // bellTimes.insert(0, 0);

    state = state.copyWith(bellTimesToRing: bellTimes.toSet());
  }

  void setBellSelected(Bell bell) async {
    state = state.copyWith(bellSelected: bell);
  }

  void setBellOnSessionStart(bool start) {
    state = state.copyWith(bellOnSessionStart: start);
  }

  void setBellOnSessionEnd(bool end) {
    state = state.copyWith(bellOnSessionEnd: end);
  }

  void setBellVolume(double volume) {
    state = state.copyWith(ambienceVolume: volume);
  }

  void setAmbienceIsOn(bool on) {
    state = state.copyWith(ambienceIsOn: on);
  }

  void setAmbienceSelected(Ambience ambience) async {
    state = state.copyWith(ambienceSelected: ambience);
    if (ambience == Ambience.none) {}
  }

  void setAmbienceVolume(double volume) {
    state = state.copyWith(ambienceVolume: volume);
  }

  void checkIfStatsUpdated(bool check) {
    state = state.copyWith(checkIfStatsUpdated: check);
  }

  void setHideClock(bool hide) {
    state = state.copyWith(hideClock: hide);
  }

  void setColorTheme(AppColorTheme colorTheme) {
    state = state.copyWith(colorTheme: colorTheme);
  }

  void setBrightness(bool isDark) {
    state = state.copyWith(isDarkTheme: isDark);
  }

  void setVibrateOnCompletion(bool vibrate) {
    state = state.copyWith(vibrateOnCompletion: vibrate);
  }

  void setDeviceIsMuted(bool muted) {
    state = state.copyWith(deviceIsMuted: muted);
  }

  void setAnimateSplash(bool animate) {
    state = state.copyWith(animateSplash: animate);
  }
}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    sessionState: SessionState.notStarted,
    //sessionHasStarted: false,
    //sessionStopped: false,
    colorTheme: AppColorTheme.turquoise,
    currentPage: 0,
    totalTimeMinutes: 60,
    initialTimeIsSet: false,
    millisecondsRemaining: 0,
    millisecondsElapsed: 0,
    pausedMilliseconds: 0,
    countdownIsOn: false,
    currentCountdownTime: 5,
    totalCountdownTime: 6,
    openSession: false,
    bellIntervalMenuSelection: {1},
    bellSelected: Bell.chime,
    selectedIntervalBellTime: 1,
    bellTimesToRing: {},
    bellVolume: 0.50,
    bellOnSessionStart: true,
    bellOnSessionEnd: true,
    ambienceIsOn: false,
    ambienceSelected: Ambience.none,
    ambienceVolume: 0.50,
    checkIfStatsUpdated: false,
    hideClock: false,
    vibrateOnCompletion: true,
    deviceIsMuted: true,
    isDarkTheme: true,
    animateSplash: false,
  ));
});

import 'package:chime/state/database_manager.dart';
import 'package:chime/enums/app_color_themes.dart';
import 'package:chime/enums/session_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/clock_design.dart';
import '../enums/focus_state.dart';
import '../enums/prefs.dart';
import '../utils/vibration_method.dart';

class AppState {
  //APP STATE
  final SessionState sessionState;
  final int currentPage;
  final bool animateHomePage;
  final bool homePageTabsAreOpen;

  //TIME
  final int totalTimeMinutes;
  final int millisecondsRemaining;
  final int millisecondsElapsed;
  final int pausedMilliseconds;
  final bool countdownIsOn;
  final int totalCountdownTime;
  final int currentCountdownTime;
  final bool openSession;

  //VIBRATE
  final bool vibrateOnCompletion;

  //MUTE
  final bool deviceIsMuted;

  //THEME
  final AppColorTheme colorTheme;
  final bool isDarkTheme;
  final bool showTimerDesign;
  final TimerDesign timerDesign;

  //SPLASH
  final bool animateSplash;

  AppState({
    required this.sessionState,
    required this.currentPage,
    required this.totalTimeMinutes,
    required this.animateHomePage,
    required this.homePageTabsAreOpen,
    required this.millisecondsRemaining,
    required this.millisecondsElapsed,
    required this.pausedMilliseconds,
    required this.countdownIsOn,
    required this.totalCountdownTime,
    required this.currentCountdownTime,
    required this.openSession,
    required this.vibrateOnCompletion,
    required this.deviceIsMuted,
    required this.colorTheme,
    required this.isDarkTheme,
    required this.showTimerDesign,
    required this.timerDesign,
    required this.animateSplash,
  });

  AppState copyWith({
    SessionState? sessionState,
    FocusState? focusState,
    int? currentPage,
    bool? animateHomePage,
    bool? homePageTabsAreOpen,
    int? totalTimeMinutes,
    int? millisecondsRemaining,
    int? millisecondsElapsed,
    int? pausedMilliseconds,
    bool? countdownIsOn,
    int? totalCountdownTime,
    int? currentCountdownTime,
    bool? openSession,
    bool? vibrateOnCompletion,
    bool? deviceIsMuted,
    AppColorTheme? colorTheme,
    bool? isDarkTheme,
    bool? showTimerDesign,
    TimerDesign? timerDesign,
    bool? animateSplash,
  }) {
    return AppState(
      sessionState: sessionState ?? this.sessionState,
      currentPage: currentPage ?? this.currentPage,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      animateHomePage: animateHomePage ?? this.animateHomePage,
      homePageTabsAreOpen: homePageTabsAreOpen ?? this.homePageTabsAreOpen,
      millisecondsRemaining:
          millisecondsRemaining ?? this.millisecondsRemaining,
      millisecondsElapsed: millisecondsElapsed ?? this.millisecondsElapsed,
      pausedMilliseconds: pausedMilliseconds ?? this.pausedMilliseconds,
      countdownIsOn: countdownIsOn ?? this.countdownIsOn,
      totalCountdownTime: totalCountdownTime ?? this.totalCountdownTime,
      currentCountdownTime: currentCountdownTime ?? this.currentCountdownTime,
      openSession: openSession ?? this.openSession,
      vibrateOnCompletion: vibrateOnCompletion ?? this.vibrateOnCompletion,
      deviceIsMuted: deviceIsMuted ?? this.deviceIsMuted,
      colorTheme: colorTheme ?? this.colorTheme,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      showTimerDesign: showTimerDesign ?? this.showTimerDesign,
      timerDesign: timerDesign ?? this.timerDesign,
      animateSplash: animateSplash ?? this.animateSplash,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTotalTime({int? minutes, int? hours, bool afterRestart = false, bool insertInDatabase = true}) async {
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

    state = state.copyWith(totalTimeMinutes: updatedTotalTime);

    if(insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.timeTotal.name, v: updatedTotalTime);
    }
  }

  void setTotalTimeAfterRestart(int total) {
    state = state.copyWith(totalTimeMinutes: total);
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
      pausedMilliseconds: 0,
      currentCountdownTime: 0,
      millisecondsRemaining: 0,
      millisecondsElapsed: 0,
    );
  }

  void setAnimateHomePage(bool animate) {
    state = state.copyWith(animateHomePage: animate);
  }

  void setHomePageTabsStatus(bool open) {
    state = state.copyWith(homePageTabsAreOpen: open);
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

  void setCountdownIsOn(bool on, {bool insertInDatabase = true}) async {
    state = state.copyWith(countdownIsOn: on);
    if(insertInDatabase){
      await DatabaseManager().insertIntoPrefs(k: Prefs.countdownIsOn.name, v: on);
    }
  }

  void setTotalCountdownTime(int time, {bool insertInDatabase = true}) async {
    state = state.copyWith(totalCountdownTime: time);
    if(insertInDatabase){
      await DatabaseManager().insertIntoPrefs(k: Prefs.timeCountdown.name, v: time);
    }
  }

  void setCurrentCountdownTime(int time) {
    state = state.copyWith(currentCountdownTime: time);
  }

  void setOpenSession(bool open, {bool insertInDatabase = true}) async {
    state = state.copyWith(openSession: open);
    if(insertInDatabase) {
      await DatabaseManager().insertIntoPrefs(
          k: Prefs.isOpenSession.name, v: !open);
    }
  }

  void setColorTheme(AppColorTheme colorTheme, {bool insertInDatabase = true}) async {
    state = state.copyWith(colorTheme: colorTheme);
    if(insertInDatabase) {
      await DatabaseManager().insertIntoPrefs(
          k: Prefs.colorTheme.name, v: colorTheme.name);
    }
  }

  void setBrightness(bool isDark, {bool insertInDatabase = true}) async {
    state = state.copyWith(isDarkTheme: isDark);
    if(insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.themeBrightness.toString(), v: isDark);
    }
  }

  void setVibrateOnCompletion(bool vibrate) {
    state = state.copyWith(vibrateOnCompletion: vibrate);

    //TODO add to database
  }

  void setDeviceIsMuted(bool muted) {
    state = state.copyWith(deviceIsMuted: muted);
    //TODO add to database
  }

  void showTimerDesign(bool show, {bool insertInDatabase = true}) async {
    state = state.copyWith(showTimerDesign: show);
    if (insertInDatabase) {
      await DatabaseManager().insertIntoPrefs(k: Prefs.timerShow.name, v: show);
    }
  }

  void setTimerDesign(TimerDesign design,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(timerDesign: design);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.timerDesign.name, v: design.name);
    }
  }

  void setAnimateSplash(bool animate) {
    state = state.copyWith(animateSplash: animate);
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    sessionState: SessionState.notStarted,
    colorTheme: AppColorTheme.turquoise,
    animateHomePage: false,
    homePageTabsAreOpen: false,
    currentPage: 0,
    totalTimeMinutes: 60,
    millisecondsRemaining: 0,
    millisecondsElapsed: 0,
    pausedMilliseconds: 0,
    countdownIsOn: false,
    currentCountdownTime: 5,
    totalCountdownTime: 5,
    openSession: false,
    vibrateOnCompletion: true,
    deviceIsMuted: true,
    isDarkTheme: true,
    showTimerDesign: true,
    timerDesign: TimerDesign.solid,
    animateSplash: false,
  ));
});

import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/app_color_themes.dart';
import '../enums/interval_bell.dart';
import '../enums/prefs.dart';

class PrefsModel {
  final bool isOpenSession;

  final int totalTime;
  final int totalCountdown;
  final bool countdownIsOn;

  final Bell bellSelected;
  final double bellVolume;
  final bool intervalBellsAreOn;
  final IntervalBell bellType;
  final double bellInterval;
  final bool bellOnStart;
  final bool bellOnEnd;

  final Ambience ambienceSelected;
  final bool ambienceIsOn;
  final double ambienceVolume;

  final bool hideClock;

  final AppColorTheme colorTheme;
  final bool brightness;

  PrefsModel({
    required this.isOpenSession,
    required this.totalTime,
    required this.totalCountdown,
    required this.countdownIsOn,
    required this.bellSelected,
    required this.bellVolume,
    required this.intervalBellsAreOn,
    required this.bellType,
    required this.bellOnStart,
    required this.bellOnEnd,
    required this.bellInterval,
    required this.ambienceSelected,
    required this.ambienceIsOn,
    required this.ambienceVolume,
    required this.hideClock,
    required this.colorTheme,
    required this.brightness,
  });

  factory PrefsModel.fromListMap(List<Map<String, dynamic>> listMap) {
    bool isOpenSession = false;
    int totalTime = 60;
    int timeCountdown = 5;
    bool countdownIsOn = true;
    Bell bellSelected = Bell.chime;
    double bellVolume = 0.50;
    bool intervalBellsAreOn = true;
    IntervalBell bellType = IntervalBell.fixed;
    double bellInterval = 1;
    bool bellOnStart = true;
    bool bellOnEnd = true;
    Ambience ambienceSelected = Ambience.none;
    double ambienceVolume = 0.5;
    bool ambienceIsOn = false;
    bool hideClock = false;
    AppColorTheme colorTheme = AppColorTheme.turquoise;
    bool brightness = true;

    for (int i = 0; i < listMap.length; i++) {
      String prefKey = listMap[i].entries.elementAt(0).value;

      if (prefKey == Prefs.isOpenSession.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          isOpenSession = false;
        } else {
          isOpenSession = true;
        }
      }

      if (prefKey == Prefs.timeTotal.name) {
        totalTime = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.timeCountdown.name) {
        timeCountdown = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.countdownIsOn.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          countdownIsOn = false;
        } else {
          countdownIsOn = true;
        }
      }

      if (prefKey == Prefs.bellSelected.name) {
        bellSelected = Bell.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => Bell.chime);
      }

      if (prefKey == Prefs.bellVolume.name) {
        bellVolume = listMap[i].entries.elementAt(1).value;
      }

      if(prefKey == Prefs.bellIntervalIsOn.name){
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          intervalBellsAreOn = false;
        } else {
          intervalBellsAreOn = true;
        }
      }
      //
      if(prefKey == Prefs.bellType.name){
        bellType = IntervalBell.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => IntervalBell.fixed);

      }

      if (prefKey == Prefs.bellInterval.name) {
        bellInterval = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellOnStart.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          bellOnStart = false;
        } else {
          bellOnEnd = true;
        }
      }

      if (prefKey == Prefs.bellOnEnd.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          bellOnEnd = false;
        } else {
          bellOnEnd = true;
        }
      }

      if (prefKey == Prefs.ambienceSelected.name) {
        ambienceSelected = Ambience.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => Ambience.none);
      }

      if (prefKey == Prefs.ambienceVolume.name) {
        ambienceVolume = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.ambienceIsOn.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          ambienceIsOn = false;
        } else {
          ambienceIsOn = true;
        }
      }


      if (prefKey == Prefs.hideClock.name) {
        hideClock = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.colorTheme.name) {
        colorTheme = AppColorTheme.values.firstWhere(
            (element) => element.name == listMap[i].entries.elementAt(1).value,
            orElse: () => AppColorTheme.turquoise);
      }

      if (prefKey == Prefs.themeBrightness.name) {
        brightness = listMap[i].entries.elementAt(1).value;
      }
    }

    return PrefsModel(
        isOpenSession: isOpenSession,
        totalTime: totalTime,
        totalCountdown: timeCountdown,
        countdownIsOn: countdownIsOn,
        bellSelected: bellSelected,
        bellInterval: bellInterval,
        intervalBellsAreOn: intervalBellsAreOn,
        bellType: bellType,
        bellVolume: bellVolume,
        bellOnStart: bellOnStart,
        bellOnEnd: bellOnEnd,
        ambienceSelected: ambienceSelected,
        ambienceVolume: ambienceVolume,
        ambienceIsOn: ambienceIsOn,
        hideClock: hideClock,
        colorTheme: colorTheme,
        brightness: brightness);
  }
}

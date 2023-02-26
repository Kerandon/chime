import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/app_color_themes.dart';
import '../enums/clock_design.dart';
import '../enums/interval_bell.dart';
import '../enums/prefs.dart';

class PrefsModel {
  final bool isOpenSession;

  final int totalTime;
  final int totalCountdown;
  final bool countdownIsOn;

  final Bell bellSelected;
  final double bellVolume;
  final bool bellIntervalIsOn;
  final BellIntervalTypeEnum bellIntervalType;
  final double bellIntervalFixedTime;
  final double bellIntervalRandomMax;
  final bool bellOnStart;
  final bool bellOnEnd;

  final Ambience ambienceSelected;
  final bool ambienceIsOn;
  final double ambienceVolume;

  final AppColorTheme colorTheme;
  final bool brightness;

  final bool timerShow;
  final TimerDesign timerDesign;

  PrefsModel({
    required this.isOpenSession,
    required this.totalTime,
    required this.totalCountdown,
    required this.countdownIsOn,
    required this.bellSelected,
    required this.bellVolume,
    required this.bellIntervalIsOn,
    required this.bellIntervalType,
    required this.bellIntervalFixedTime,
    required this.bellIntervalRandomMax,
    required this.bellOnStart,
    required this.bellOnEnd,
    required this.ambienceSelected,
    required this.ambienceIsOn,
    required this.ambienceVolume,
    required this.colorTheme,
    required this.brightness,
    required this.timerShow,
    required this.timerDesign,
  });

  factory PrefsModel.fromListMap(List<Map<String, dynamic>> listMap) {
    bool isOpenSession = false;
    int totalTime = 60;
    int timeCountdown = 5;
    bool countdownIsOn = true;

    Ambience ambienceSelected = Ambience.none;
    double ambienceVolume = 0.5;
    bool ambienceIsOn = false;

    Bell bellSelected = Bell.chime;
    double bellVolume = 0.50;
    bool bellIntervalIsOn = true;
    BellIntervalTypeEnum bellIntervalType = BellIntervalTypeEnum.fixed;
    double bellIntervalFixedTime = 1;
    double bellIntervalRandomMax = 5;
    bool bellOnStart = true;
    bool bellOnEnd = true;

    AppColorTheme colorTheme = AppColorTheme.turquoise;
    bool brightness = true;

    bool timerShow = true;
    TimerDesign timerDesign = TimerDesign.solid;

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

      if (prefKey == Prefs.bellIntervalIsOn.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          bellIntervalIsOn = false;
        } else {
          bellIntervalIsOn = true;
        }
      }

      if (prefKey == Prefs.bellIntervalType.name) {
        bellIntervalType = BellIntervalTypeEnum.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => BellIntervalTypeEnum.fixed);
      }

      if (prefKey == Prefs.bellIntervalFixedTime.name) {
        bellIntervalFixedTime = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellIntervalRandomMax.name) {
        bellIntervalRandomMax = listMap[i].entries.elementAt(1).value;
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

      if (prefKey == Prefs.colorTheme.name) {
        colorTheme = AppColorTheme.values.firstWhere(
            (element) => element.name == listMap[i].entries.elementAt(1).value,
            orElse: () => AppColorTheme.turquoise);
      }

      if (prefKey == Prefs.themeBrightness.name) {
        brightness = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.timerShow.name) {
        final value = listMap[i].entries.elementAt(1).value;
        if (value == 0) {
          timerShow = false;
        } else {
          timerShow = true;
        }
      }

      if (prefKey == Prefs.timerDesign.name) {
        timerDesign = TimerDesign.values.firstWhere(
            (element) => element.name == listMap[i].entries.elementAt(1).value,
            orElse: () => TimerDesign.solid);
      }
    }

    return PrefsModel(
      isOpenSession: isOpenSession,
      totalTime: totalTime,
      totalCountdown: timeCountdown,
      countdownIsOn: countdownIsOn,
      bellSelected: bellSelected,
      bellIntervalFixedTime: bellIntervalFixedTime,
      bellIntervalIsOn: bellIntervalIsOn,
      bellIntervalType: bellIntervalType,
      bellVolume: bellVolume,
      bellOnStart: bellOnStart,
      bellOnEnd: bellOnEnd,
      bellIntervalRandomMax: bellIntervalRandomMax,
      ambienceSelected: ambienceSelected,
      ambienceVolume: ambienceVolume,
      ambienceIsOn: ambienceIsOn,
      colorTheme: colorTheme,
      brightness: brightness,
      timerShow: timerShow,
      timerDesign: timerDesign,
    );
  }
}

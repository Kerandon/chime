import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/color_themes.dart';
import '../enums/prefs.dart';

class PrefsModel {
  final int totalTime;
  final int bellInterval;
  final Bell bellSelected;
  final double bellVolume;
  final Ambience ambienceSelected;
  final double ambienceVolume;
  final int countdownTime;

  PrefsModel({
    required this.totalTime,
    required this.bellInterval,
    required this.bellSelected,
    required this.bellVolume,
    required this.ambienceSelected,
    required this.ambienceVolume,
    required this.countdownTime,
  });
}

class PrefsModel2 {
  final ColorTheme colorTheme;
  final int totalTime;
  final int totalCountdown;

  final Bell bellSelected;
  final double bellVolume;
  final int bellInterval;
  final bool bellOnStart;

  final Ambience ambienceSelected;
  final double ambienceVolume;

  final bool hideClock;

  PrefsModel2({
    required this.totalTime,
    required this.totalCountdown,
    required this.bellSelected,
    required this.bellVolume,
    required this.bellOnStart,
    required this.bellInterval,
    required this.ambienceSelected,
    required this.ambienceVolume,
    required this.hideClock,
    required this.colorTheme,
  });

  factory PrefsModel2.fromMap(List<Map<String, dynamic>> mapList) {
    int totalTime = 60;
    int timeCountdown = 5;
    Ambience ambienceSelected = Ambience.none;
    double ambienceVolume = 0.5;
    Bell bellSelected = Bell.chime;
    double bellVolume = 0.50;
    int bellInterval = 1;
    bool bellOnStart = true;
    bool hideClock = false;
    ColorTheme colorTheme = ColorTheme.darkTeal;

    for (int i = 0; i < mapList.length; i++) {
      String prefKey = mapList[i].entries.elementAt(0).value;

      if (prefKey == Prefs.timeTotal.name) {
        totalTime = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.timeCountdown.name) {
        timeCountdown = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.ambienceSelected.name) {
        ambienceSelected = Ambience.values.firstWhere((element) {
          return element.name == mapList[i].entries.elementAt(1).value;
        }, orElse: () => Ambience.none);
      }

      if (prefKey == Prefs.ambienceVolume.name) {
        ambienceVolume = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellSelected.name) {
        bellSelected = Bell.values.firstWhere((element) {
          return element.name == mapList[i].entries.elementAt(1).value;
        }, orElse: () => Bell.chime);
      }

      if (prefKey == Prefs.bellVolume.name) {
        bellVolume = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellInterval.name) {
        bellInterval = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellOnStart.name) {
        bellOnStart = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.hideClock.name) {
        hideClock = mapList[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.colorTheme.name) {
        colorTheme = ColorTheme.values.firstWhere(
            (element) => element.name == mapList[i].entries.elementAt(1).value,
            orElse: () => ColorTheme.darkTeal);
      }
    }

    return PrefsModel2(
      totalTime: totalTime,
      totalCountdown: timeCountdown,
      bellSelected: bellSelected,
      bellInterval: bellInterval,
      bellVolume: bellVolume,
      bellOnStart: bellOnStart,
      ambienceSelected: ambienceSelected,
      ambienceVolume: ambienceVolume,
      hideClock: hideClock,
      colorTheme: colorTheme,
    );
  }
}

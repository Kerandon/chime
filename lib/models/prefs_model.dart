import '../configs/app_colors.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/app_color_themes.dart';
import '../enums/prefs.dart';

class PrefsModel {

  final int totalTime;
  final int totalCountdown;

  final Bell bellSelected;
  final double bellVolume;
  final int bellInterval;
  final bool bellOnStart;

  final Ambience ambienceSelected;
  final double ambienceVolume;

  final bool hideClock;

  final AppColorTheme colorTheme;
  final bool brightness;

  PrefsModel({
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
    required this.brightness,
  });

  factory PrefsModel.fromListMap(List<Map<String, dynamic>> listMap) {
    int totalTime = 60;
    int timeCountdown = 5;
    Ambience ambienceSelected = Ambience.none;
    double ambienceVolume = 0.5;
    Bell bellSelected = Bell.chime;
    double bellVolume = 0.50;
    int bellInterval = 1;
    bool bellOnStart = true;
    bool hideClock = false;
    AppColorTheme colorTheme = AppColorTheme.turquoise;
    bool brightness = true;

    for (int i = 0; i < listMap.length; i++) {
      String prefKey = listMap[i].entries.elementAt(0).value;

      if (prefKey == Prefs.timeTotal.name) {
        totalTime = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.timeCountdown.name) {
        timeCountdown = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.ambienceSelected.name) {
        ambienceSelected = Ambience.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => Ambience.none);
      }

      if (prefKey == Prefs.ambienceVolume.name) {
        ambienceVolume = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellSelected.name) {
        bellSelected = Bell.values.firstWhere((element) {
          return element.name == listMap[i].entries.elementAt(1).value;
        }, orElse: () => Bell.chime);
      }

      if (prefKey == Prefs.bellVolume.name) {
        bellVolume = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellInterval.name) {
        bellInterval = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.bellOnStart.name) {
        bellOnStart = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.hideClock.name) {
        hideClock = listMap[i].entries.elementAt(1).value;
      }

      if (prefKey == Prefs.colorTheme.name) {
        colorTheme = AppColorTheme.values.firstWhere(
            (element) => element.name == listMap[i].entries.elementAt(1).value,
            orElse: () => AppColorTheme.turquoise);
      }

      if(prefKey == Prefs.themeBrightness.name){
        brightness = listMap[i].entries.elementAt(1).value;
      }
    }

    return PrefsModel(
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
      brightness: brightness
    );
  }
}

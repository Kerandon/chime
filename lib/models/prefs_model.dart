import 'package:chime/database_manager.dart';

import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/color_themes.dart';

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

  PrefsModel2({required this.colorTheme});

  PrefsModel2 copyWith({ColorTheme? colorTheme}) {
    return PrefsModel2(
      colorTheme: colorTheme ?? ColorTheme.darkTeal,
    );
  }

  factory PrefsModel2.fromMap({required Map<String, dynamic> map}) {


    final colorTheme = ColorTheme.values.firstWhere((element) => element.name == map[DatabaseManager.column2Prefs],
        orElse: () => ColorTheme.darkTeal);

    return PrefsModel2(
        colorTheme: colorTheme,
    );
  }
}

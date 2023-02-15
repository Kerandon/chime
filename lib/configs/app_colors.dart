import 'package:chime/models/theme_color_model.dart';
import 'package:flutter/material.dart';

import '../enums/app_color_themes.dart';

class AppColors {
  static List<ThemeColorModel> themeColors = [
    ThemeColorModel(AppColorTheme.amber, const Color.fromARGB(255, 255, 191, 0)),
    ThemeColorModel(AppColorTheme.cream, const Color.fromARGB(255, 203, 204, 164)),
    ThemeColorModel(AppColorTheme.crimson, const Color.fromARGB(255, 220, 20, 60)),
    ThemeColorModel(AppColorTheme.sky, const Color.fromARGB(255, 149, 200, 216)),
    ThemeColorModel(AppColorTheme.turquoise, const Color.fromARGB(255, 48, 213, 200)),
    ThemeColorModel(AppColorTheme.tangerine, const Color.fromARGB(255, 250, 129, 40)),
  ];

  // static Map<String, Color> colorThemes = {
  //   'Amber': Color.fromARGB(255, 255, 191, 0),
  //   'Cream': Color.fromARGB(255, 203, 204, 164),
  //   'Crimson': Color.fromARGB(255, 220, 20, 60),
  //   'Navy': Color.fromARGB(255, 0, 0, 128),
  //   'Sky': Color.fromARGB(255, 149, 200, 216),
  //   'Turquoise': Color.fromARGB(255, 63, 224, 208)
  // };

  // static const amber = Color.fromARGB(255, 255, 191, 0);
  // static const cobalt = Color.fromARGB(255, 19, 56, 190);
  // static const cream = Color.fromARGB(255, 203, 204, 164);
  // static const crimson = Color.fromARGB(255, 220, 20, 60);
  // static const navy = Color.fromARGB(255, 0, 0, 128);
  // static const sky = Color.fromARGB(255, 149, 200, 216);
  //
  // static const tangerine = Color.fromARGB(255, 242, 133, 0);
  // static const turquoise = Color.fromARGB(255, 63, 224, 208);

  static const lightGrey = Color.fromARGB(255, 211, 211, 211);
  static const grey = Color.fromARGB(255, 110, 110, 110);
  static const darkGrey = Color.fromARGB(255, 50, 50, 50);
  static const veryDarkGrey = Color.fromARGB(255, 25, 25, 25);
  static const almostBlack = Color.fromARGB(255, 5, 5, 5);
}

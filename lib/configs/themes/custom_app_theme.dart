import 'package:flutter/material.dart';
import '../../enums/app_color_themes.dart';
import '../app_colors.dart';

class CustomAppTheme {
  ThemeData _getThemeData(
      {required Color primaryColor, required Brightness brightness}) {
    return ThemeData(
      textTheme: const TextTheme(displaySmall: TextStyle(fontSize: 30)),
      brightness: brightness,
      secondaryHeaderColor: AppColors.grey,
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor:
                  brightness == Brightness.dark ? Colors.white : Colors.black,
              side: BorderSide(
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ))),
      sliderTheme: SliderThemeData(
          thumbColor: Colors.white, activeTrackColor: primaryColor),
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all<Color>(primaryColor)),
      primaryColor: primaryColor,
      primaryColorLight: Colors.grey,
      primaryColorDark: Colors.black,
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all<Color>(primaryColor),
        thumbColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0, selectedItemColor: primaryColor),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor
      ),
      useMaterial3: true,
    );
  }

  static ThemeData getThemeData(
      {required AppColorTheme theme, required Brightness brightness}) {
    Color color = AppColors.themeColors
        .firstWhere((element) => element.color.name == theme.name)
        .arbg;

    return CustomAppTheme()
        ._getThemeData(primaryColor: color, brightness: brightness);
  }
}

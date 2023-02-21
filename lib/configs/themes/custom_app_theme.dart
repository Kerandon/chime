import 'package:flutter/material.dart';
import '../../enums/app_color_themes.dart';
import '../app_colors.dart';

class CustomAppTheme {
  ThemeData _getThemeData(
      {
        required Color primaryColor,
      required Brightness brightness}) {
    return ThemeData(
      brightness: brightness,
      secondaryHeaderColor: AppColors.grey,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // foregroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.white
          )
        )
      ),
      sliderTheme: SliderThemeData(
        thumbColor: Colors.white,
        activeTrackColor: primaryColor
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)
      ),

      primaryColor: primaryColor,
      primaryColorLight: Colors.grey,
      primaryColorDark: Colors.black,
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all<Color>(primaryColor),
        thumbColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      useMaterial3: true,
    );
  }
  static ThemeData getThemeData(
      {required AppColorTheme theme, required Brightness brightness}) {

    Color color = AppColors.themeColors.firstWhere((element) => element.color.name == theme.name).arbg;

    return CustomAppTheme()._getThemeData(primaryColor: color, brightness: brightness);

    // switch (theme) {

    //   case AppColorTheme.amber:
    //    return CustomAppTheme()._getThemeData(primaryColor: AppColors.amber, brightness: brightness);
    //   case AppColorTheme.cream:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.cream, brightness: brightness);
    //   case AppColorTheme.crimson:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.crimson, brightness: brightness);
    //
    //
    //   case AppColorTheme.navy:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.navy, brightness: brightness);
    //
    //   case AppColorTheme.sky:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.sky, brightness: brightness);
    //   case AppColorTheme.tangerine:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.tangerine, brightness: brightness);
    //   case AppColorTheme.turquoise:
    //     return CustomAppTheme()._getThemeData(primaryColor: AppColors.turquoise, brightness: brightness);
    // }
  }
}

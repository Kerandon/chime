import 'package:flutter/material.dart';

import '../app_colors.dart';

const darkThemeTextStyle = TextStyle(color: Colors.white);
const lightThemeTextStyle = TextStyle(color: Colors.black);

TextTheme darkThemeTextTheme() {
  return TextTheme(
    bodySmall: darkThemeTextStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w200,
    ),
    bodyMedium: darkThemeTextStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w200,
    ),
    displaySmall: darkThemeTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w200,
    ),
    displayMedium: darkThemeTextStyle.copyWith(
      fontSize: 50,
      fontWeight: FontWeight.w200,
    ),
    displayLarge: darkThemeTextStyle.copyWith(
      fontSize: 60,
      fontWeight: FontWeight.w200,
    ),
    labelSmall: darkThemeTextStyle.copyWith(
      fontSize: 10,
      color: AppColors.offWhite
    ),
  );
}


TextTheme lightThemeTextTheme() {
  return TextTheme(
    bodySmall: lightThemeTextStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyMedium: lightThemeTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w300,
    ),
    displaySmall: lightThemeTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: lightThemeTextStyle.copyWith(
      fontSize: 25,
      fontWeight: FontWeight.w100,
    ),
    displayLarge: lightThemeTextStyle.copyWith(
      fontSize: 50,
      fontWeight: FontWeight.w100,
    ),
    labelSmall: lightThemeTextStyle,
  );
}



import 'package:flutter/material.dart';

const darkThemeTextStyle = TextStyle(color: Colors.white);
const lightThemeTextStyle = TextStyle(color: Colors.black);

TextTheme darkThemeTextTheme() {
  return TextTheme(
    bodySmall: darkThemeTextStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyMedium: darkThemeTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w300,
    ),
    displaySmall: darkThemeTextStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: darkThemeTextStyle.copyWith(
      fontSize: 25,
      fontWeight: FontWeight.w100,
    ),
    displayLarge: darkThemeTextStyle.copyWith(
      fontSize: 80,
      fontWeight: FontWeight.w300,
    ),
    labelSmall: darkThemeTextStyle,
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



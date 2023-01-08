import 'package:flutter/material.dart';

final appTheme = ThemeData(
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white)),
  ),
  textTheme: TextTheme(
      bodySmall: defaultTextStyle.copyWith(
        fontSize: 15,
      ),
      displaySmall:
          defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      displayLarge: defaultTextStyle.copyWith(fontSize: 120),
      labelSmall: defaultTextStyle),
  iconTheme: const IconThemeData(color: Colors.white, size: 40),
);
const defaultTextStyle = TextStyle(color: Colors.white);

import 'package:chime/utils/constants.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.teal,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200)),
  ),
  textTheme: TextTheme(
      bodySmall: defaultTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w200
      ),
      displaySmall:
          defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w300),
      displayLarge: defaultTextStyle.copyWith(fontSize: 120, fontWeight: FontWeight.w100),
      labelSmall: defaultTextStyle),
  iconTheme: const IconThemeData(color: Colors.white, size: 30),
  dialogTheme: DialogTheme(
    alignment: Alignment.center,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
    ),
    elevation: 5,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0, iconTheme: IconThemeData(size: 15)),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      alignment: Alignment.center,
      foregroundColor: Colors.black,
      textStyle: defaultTextStyle.copyWith(color: Colors.black),
    ),
  ),
);
const defaultTextStyle = TextStyle(color: Colors.white);

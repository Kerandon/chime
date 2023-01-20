import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.teal,

  textTheme: TextTheme(
      bodySmall: defaultTextStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
      bodyMedium: defaultTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      displaySmall: defaultTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      displayMedium: defaultTextStyle.copyWith(
        fontSize: 25,
        fontWeight: FontWeight.w100,
      ),
      displayLarge: defaultTextStyle.copyWith(
        fontSize: 50,
        fontWeight: FontWeight.w100,
      ),
      labelSmall: defaultTextStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w200,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white, size: 22),
  dialogTheme: DialogTheme(
    alignment: Alignment.center,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
    ),
    elevation: 5,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: defaultTextStyle.copyWith(
      fontSize: 15
    ),
  ),
  scaffoldBackgroundColor: AppColors.almostBlack,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      alignment: Alignment.center,
      foregroundColor: Colors.black,
      textStyle: defaultTextStyle.copyWith(color: Colors.black),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.teal,
  ),
  sliderTheme: SliderThemeData(
    thumbColor: AppColors.teal,
    activeTrackColor: AppColors.teal,
    inactiveTrackColor: Colors.grey.withOpacity(0.50),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(Colors.teal)
  )
);
const defaultTextStyle = TextStyle(color: Colors.white);

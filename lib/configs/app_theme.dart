import 'package:chime/utils/constants.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
    primaryColor: AppColors.teal,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
        ),
      ),
    ),
    textTheme: TextTheme(
        bodySmall: defaultTextStyle.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: defaultTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
        displaySmall: defaultTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        displayMedium: defaultTextStyle.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w300,
        ),
        displayLarge: defaultTextStyle.copyWith(
          fontSize: 80,
          fontWeight: FontWeight.w100,
        ),
        labelSmall: defaultTextStyle),
    iconTheme: const IconThemeData(color: Colors.white, size: 30),
    dialogTheme: DialogTheme(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      elevation: 5,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,),
    scaffoldBackgroundColor: AppColors.almostBlack,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        alignment: Alignment.center,
        foregroundColor: Colors.black,
        textStyle: defaultTextStyle.copyWith(color: Colors.black),
      ),
    ),
    sliderTheme: SliderThemeData(
        thumbColor: AppColors.teal,
        activeTrackColor: AppColors.teal,
        inactiveTrackColor: Colors.grey.withOpacity(0.50)));
const defaultTextStyle = TextStyle(color: Colors.white);

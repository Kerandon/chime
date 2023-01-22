import 'package:chime/configs/themes/dark_teal_theme.dart';
import 'package:chime/configs/themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

final lightTheme = darkTealTheme.copyWith(
  primaryColor: AppColors.tealPrimary,
  textTheme: lightThemeTextTheme(),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w200,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black, size: 22),
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: Colors.black,),
    backgroundColor: AppColors.offWhite,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: lightThemeTextStyle.copyWith(fontSize: 15),
  ),
  scaffoldBackgroundColor: AppColors.offWhiteLight,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      alignment: Alignment.center,
      foregroundColor: Colors.white10,
      textStyle: lightThemeTextStyle,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Colors.black,
    iconColor: Colors.black
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(AppColors.tealPrimary),
  ),
);

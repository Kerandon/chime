import 'package:chime/configs/themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constants.dart';

final darkTealTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.tealPrimary,
    primaryColorLight: AppColors.tealLight,
    primaryColorDark: AppColors.tealDark,
    secondaryHeaderColor: AppColors.grey,
    textTheme: darkThemeTextTheme(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 22),
    dialogBackgroundColor: AppColors.darkGrey,
    dialogTheme: DialogTheme(

      backgroundColor: AppColors.darkGrey,
      titleTextStyle: darkThemeTextStyle,
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
      titleTextStyle: darkThemeTextStyle.copyWith(fontSize: 15),
    ),
    scaffoldBackgroundColor: AppColors.almostBlack,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        alignment: Alignment.center,
        foregroundColor: Colors.black,
        textStyle: darkThemeTextStyle.copyWith(color: Colors.black),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.tealPrimary,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: AppColors.tealPrimary,
      activeTrackColor: AppColors.tealPrimary,
      inactiveTrackColor: Colors.grey.withOpacity(0.50),
    ),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(AppColors.tealPrimary)),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(AppColors.tealPrimary),
      trackColor: MaterialStateProperty.all<Color>(AppColors.tealDark),
      overlayColor: MaterialStateProperty.all<Color>(AppColors.lightGrey),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.almostBlack,
        selectedIconTheme: IconThemeData(color: AppColors.tealPrimary),
        selectedLabelStyle: TextStyle(color: AppColors.tealPrimary),
        selectedItemColor: AppColors.tealPrimary,
        unselectedItemColor: Colors.grey),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: darkThemeTextStyle
  ),

);

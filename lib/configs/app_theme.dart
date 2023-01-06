import 'package:flutter/material.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.lightGrey,
          textStyle: TextStyle(color: Colors.black)),
    ),
    textTheme: TextTheme(
labelSmall: defaultTextStyle
    ),);
final defaultTextStyle = TextStyle(color: Colors.black);

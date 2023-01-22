import 'package:chime/configs/themes/dark_teal_theme.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

final darkOrangeTheme = darkTealTheme.copyWith(
  primaryColor: AppColors.orangePrimary,
  dividerTheme: const DividerThemeData(
    color: AppColors.orangePrimary,
  ),
  sliderTheme: const SliderThemeData(
    thumbColor: AppColors.tealPrimary,
    activeTrackColor: AppColors.tealPrimary,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(AppColors.orangePrimary),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.orangePrimary),
    trackColor: MaterialStateProperty.all<Color>(AppColors.orangeDark),
  ),
);

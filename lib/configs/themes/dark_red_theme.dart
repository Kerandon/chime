import 'package:chime/configs/themes/dark_teal_theme.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

final darkRedTheme = darkTealTheme.copyWith(
  primaryColor: AppColors.redPrimary,
  primaryColorDark: AppColors.redDark,
  dividerTheme: const DividerThemeData(
    color: AppColors.redPrimary,
  ),
  sliderTheme: const SliderThemeData(
    thumbColor: AppColors.redPrimary,
    activeTrackColor: AppColors.redDark,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(AppColors.redPrimary),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.redPrimary),
    trackColor: MaterialStateProperty.all<Color>(AppColors.redDark),
  ),
);

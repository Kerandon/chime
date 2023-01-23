import 'package:chime/configs/themes/dark_teal_theme.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

final darkBlueTheme = darkTealTheme.copyWith(
  primaryColor: AppColors.bluePrimary,
  dividerTheme: const DividerThemeData(
    color: AppColors.bluePrimary,
  ),
  sliderTheme: const SliderThemeData(
    thumbColor: AppColors.bluePrimary,
    activeTrackColor: AppColors.blueDark,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(AppColors.bluePrimary),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(AppColors.bluePrimary),
    trackColor: MaterialStateProperty.all<Color>(AppColors.blueDark),
  ),
);

import 'package:chime/utils/methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';

BarTouchData getBarTouchData({required bool showLabels}) {
  return BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        String time = "";
        if (showLabels) {
          time = rod.toY.round().formatToHourMin();
        }
        return BarTooltipItem(
          time,
          const TextStyle(color: AppColors.offWhite, fontSize: 10),
        );
      },
    ),
  );
}
import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../configs/app_colors.dart';

class StreakStatsBox extends StatelessWidget {
  const StreakStatsBox({
    super.key,
    required this.text,
    required this.value,
    this.fontSize,
  });

  final String value;
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).primaryColor,
              fontSize: fontSize

                ),
          ),
          Text(

            text,              textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
              fontSize: kChartAxisFontSize
                ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

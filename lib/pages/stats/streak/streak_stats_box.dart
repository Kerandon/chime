import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 150
          ),
        ).animate().fadeIn().scaleXY(begin: 0.95),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

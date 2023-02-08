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
          ),
        ).animate().fadeIn(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 12),
        ),
      ],
    );
  }
}

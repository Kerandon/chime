import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';

class StreakStatsBox extends StatelessWidget {
  const StreakStatsBox({
    super.key,
    required this.text,
    required this.value,
  });

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).primaryColor,
                fontSize: 25

                ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.offWhite,
                ),
          ),
        ],
      ),
    );
  }
}

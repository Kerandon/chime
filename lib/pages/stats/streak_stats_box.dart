

import 'package:flutter/material.dart';

class StreakStatsBox extends StatelessWidget {
  const StreakStatsBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '5',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Current Streak',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}

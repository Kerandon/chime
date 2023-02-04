
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../enums/time_period.dart';
import '../../../models/stats_model.dart';
import '../../../state/chart_state.dart';
import '../../../utils/methods.dart';

class TotalMeditationTimeTitle extends ConsumerWidget {
  const TotalMeditationTimeTitle({required this.statsData,
    super.key,
  });

  final List<StatsModel> statsData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartStateProvider);


    if (statsData.isNotEmpty) {
      String totalText = calculateTotalMeditationTime(statsData, state);
      String periodText = " in total";

      TimePeriod? period = statsData.first.timePeriod;
      switch (period!) {
        case TimePeriod.week:
          periodText = ' in the last week';
          break;
        case TimePeriod.fortnight:
          periodText = ' in the last fortnight';
          break;
        case TimePeriod.year:
          periodText = ' in the last year';
          break;
        case TimePeriod.allTime:
          ' in total';
          break;
      }

      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: period == TimePeriod.allTime ? 'You have meditated for ' : 'You meditated for ',
          style: Theme
              .of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w300),
          children: [
            TextSpan(
              text: totalText,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme
                      .of(context)
                      .primaryColor),
            ),
            TextSpan(
                text: periodText,
                style:
                Theme
                    .of(context)
                    .textTheme
                    .bodySmall
            ),
          ],
        ),
      ).animate().fadeIn();
    } else return SizedBox.shrink();
  }
}

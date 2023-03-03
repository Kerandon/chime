import 'package:chime/configs/constants.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/stats_model.dart';
import '../../state/database_manager.dart';

class LastMeditationTimeTitle extends ConsumerStatefulWidget {
  const LastMeditationTimeTitle({
    super.key,
  });

  @override
  ConsumerState<LastMeditationTimeTitle> createState() =>
      _LastMeditationTimeTitleState();
}

class _LastMeditationTimeTitleState extends ConsumerState<LastMeditationTimeTitle> {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<StatsModel>(

      future: DatabaseManager().getLastEntry(),
      builder: (context, snapshot) {
        String lastMeditation = '';
        String lastMeditationDays = '';
        if (snapshot.hasData) {
          StatsModel lastEntry = snapshot.data!;
          lastMeditation = lastEntry.totalMeditationTime.formatToHourMin();
          DateTime now = DateTime.now();

          int daysSinceLastMeditation =
              now
                  .difference(lastEntry.dateTime)
                  .inDays;

          if (daysSinceLastMeditation == 0) {
            lastMeditationDays = 'today';
          } else if (daysSinceLastMeditation == 1) {
            lastMeditationDays = 'yesterday';
          } else {
            lastMeditationDays = '$daysSinceLastMeditation days ago';
          }
        }else{
          lastMeditationDays = '0 days ago';
          lastMeditation = '0 minutes';
                  }

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You last meditated ',
              style: Theme.of(context).textTheme.displaySmall,
              children: [
                TextSpan(
                  text: lastMeditationDays,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                const TextSpan(
                  text: ' for ',
                ),
                TextSpan(
                  text: lastMeditation,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.milliseconds, duration: kFadeInTimeMilliseconds.milliseconds);
      },
    );
  }
}

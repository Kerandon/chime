import 'package:chime/enums/time_period.dart';
import 'package:chime/pages/stats/streak_stats_box.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/stats_model.dart';
import '../../state/chart_state.dart';
import '../../state/database_manager.dart';
import '../../utils/methods.dart';

class StreakStats extends ConsumerStatefulWidget {
  const StreakStats({
    super.key,
  });

  @override
  ConsumerState<StreakStats> createState() => _StreakStatsState();
}

class _StreakStatsState extends ConsumerState<StreakStats> {
  // late final Future<StatsModel> _lastEntryFuture;
  late final Future<List<StatsModel>> _allGroupedFuture;

  @override
  void initState() {
    // _lastEntryFuture = DatabaseManager().getLastEntry();
    _allGroupedFuture = DatabaseManager().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(chartStateProvider.notifier);
    return FutureBuilder(
      future: _allGroupedFuture,
      // Future.wait([_lastEntryFuture,
      //   _allGroupedFuture]),
      builder: (context, snapshot) {
        // String lastMeditation = '';
        // String lastMeditationDate = '';
        String currentStreakString = '';
        String bestStreak = '';
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setChartsHaveData(snapshot.hasData);
        });
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            // StatsModel lastEntry = snapshot.data! as StatsModel;
            // lastMeditation = lastEntry.totalMeditationTime.formatToHourMin();
            // final date = lastEntry.dateTime;
            // final DateFormat formatter = DateFormat.yMMMd();
            // lastMeditationDate = formatter.format(date);
            // lastMeditationDate = ' on $lastMeditationDate';

            List<StatsModel> stats = snapshot.data! as List<StatsModel>;
            currentStreakString = getCurrentStreak(stats);
            bestStreak = getBestStreak(stats);
          }
        }
        return Column(
          children: [
            StreakStatsBox(
              value: currentStreakString,
              text: 'Current streak',
              fontSize: 80,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                StreakStatsBox(
                  value: bestStreak,
                  text: 'Best streak\n',
                ),
                // StreakStatsBox(
                //   value: lastMeditation,
                //   text: 'Last meditation\n$lastMeditationDate',
                // ),
              ],
            ),
          ],
        );
      },
    );
  }
}

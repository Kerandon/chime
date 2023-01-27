import 'package:chime/pages/stats/streak_stats_box.dart';
import 'package:flutter/material.dart';

import '../../models/stats_model.dart';
import '../../state/database_manager.dart';
import '../../utils/methods.dart';

class StreakStats extends StatefulWidget {
  const StreakStats({
    super.key,
  });

  @override
  State<StreakStats> createState() => _StreakStatsState();
}

class _StreakStatsState extends State<StreakStats> {
  late final Future<StatsModel> _lastEntryFuture;
  late final Future<List<StatsModel>> _allGroupedFuture;

  @override
  void initState() {
    _lastEntryFuture = DatabaseManager().getLastEntry();
    _allGroupedFuture =
        DatabaseManager().getStatsByTimePeriod(allTimeGroupedByDay: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_lastEntryFuture, _allGroupedFuture]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsModel lastEntry = snapshot.data![0] as StatsModel;
          List<StatsModel> stats = snapshot.data![1] as List<StatsModel>;
          String currentStreakString = getCurrentStreak(stats);
          String bestStreak = getBestStreak(stats);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreakStatsBox(
                value: lastEntry.totalMeditationTime.formatToHourMin(),
                text: 'Last meditation',
              ),
              StreakStatsBox(
                value: currentStreakString,
                text: 'Current streak',
              ),
              StreakStatsBox(
                value: bestStreak,
                text: 'Best streak',
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

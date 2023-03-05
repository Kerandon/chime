import 'package:chime/enums/time_period.dart';
import 'package:chime/pages/stats/streak/streak_stats_box.dart';
import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_circular_progress.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_manager.dart';
import '../../../utils/methods/stats_methods.dart';

class StreakStats extends ConsumerStatefulWidget {
  const StreakStats({
    super.key,
  });

  @override
  ConsumerState<StreakStats> createState() => _StreakStatsState();
}

class _StreakStatsState extends ConsumerState<StreakStats> {
  late final Future _allGroupedFuture;

  @override
  void initState() {
    _allGroupedFuture = DatabaseManager().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allGroupedFuture,
      builder: (context, snapshot) {
        List<StatsModel> stats = [];
        String currentStreakString = '0';
        String bestStreak = '0';
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingIndicator();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            stats = snapshot.data!;
            currentStreakString = getCurrentStreak(stats).toString();
            bestStreak = getBestStreak(stats).toString();
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
      },
    );
  }
}

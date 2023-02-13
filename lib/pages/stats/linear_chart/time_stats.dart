import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/day_time.dart';
import '../../../models/day_time_model.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_manager.dart';
import 'legend_key.dart';
import 'linear_chart.dart';

class TimeStats extends ConsumerStatefulWidget {
  const TimeStats({
    super.key,
  });

  @override
  ConsumerState<TimeStats> createState() => _TimeStatsState();
}

class _TimeStatsState extends ConsumerState<TimeStats> {
  late final Future<List<StatsModel>> _statsFuture;
  bool _animate = false;

  @override
  void initState() {
    _statsFuture = DatabaseManager().getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(chartStateProvider);
    final notifier = ref.watch(chartStateProvider.notifier);
    if (state.pageScrollOffset / size.height > 1.30 &&
        !state.linearChartHasAnimated) {
      _animate = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setLinearChartHasAnimated(true);
      });
    }

    return FutureBuilder<List<StatsModel>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        List<Color> colors = [
          const Color.fromARGB(255, 140, 255, 240),
          const Color.fromARGB(255, 44, 118, 33),
          const Color.fromARGB(255, 230, 105, 18),
          const Color.fromARGB(255, 90, 51, 110),

        ];

        List<DateTime> dateTimeStats = [];

        Map<DayTime, int> dayTimesTotals = {
          DayTime.morning: 0,
          DayTime.afternoon: 0,
          DayTime.evening: 0,
          DayTime.lateNight: 0
        };
        List<DayTimeModel> dayTimes = [];

        /// Morning 3-11.59; 180M to 719M
        /// Afternoon 12-17.59; 720M to 1079M
        /// Evening 18-20.59; 1080M to 1259M
        /// Late night 21-2.59; 1260M to 179M

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          for (var s in snapshot.data!) {
            dateTimeStats.add(s.dateTime);
          }

          for (var d in dateTimeStats) {
            int timeInMinutes = (d.hour * 60) + d.minute;

            if (timeInMinutes >= 180 && timeInMinutes <= 719) {
              dayTimesTotals.update(DayTime.morning, (value) => value + 1);
            } else if (timeInMinutes >= 720 && timeInMinutes <= 1079) {
              dayTimesTotals.update(DayTime.afternoon, (value) => value + 1);
            } else if (timeInMinutes >= 1080 && timeInMinutes <= 1259) {
              dayTimesTotals.update(DayTime.evening, (value) => value + 1);
            } else {
              dayTimesTotals.update(DayTime.lateNight, (value) => value + 1);
            }
          }
        }
        final values = dayTimesTotals.values;
        final totalEntries =
            values.fold(0, (previousValue, element) => previousValue + element);

        for (int i = 0; i < DayTime.values.length; i++) {
          final e = dayTimesTotals.entries;
          dayTimes.add(
            DayTimeModel(
                time: e.elementAt(i).key,
                percent: snapshot.hasData && snapshot.data!.isNotEmpty
                    ? e.elementAt(i).value / totalEntries
                    : 0,
                color: colors[i]),
          );
        }

        final size = MediaQuery.of(context).size;

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _animate
                  ? Text(
                      'Your preferred times to meditate',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ).animate().fadeIn()
                  : const SizedBox.shrink(),
              _animate
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.04),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(
                          dayTimes.length,
                          (index) => LegendKey(
                            text: dayTimes[index].time.toText(),
                            color: dayTimes[index].color,
                            percent: dayTimes[index].percent,
                          ),
                        ),
                      ),
                    ).animate().fadeIn().scaleXY(begin: 0.95)
                  : const SizedBox.shrink(),
              AnimatedContainer(
                  width: _animate ? size.width * 0.90 : 0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: LinearChart(
                    dayTimes: dayTimes,
                  ))
            ],
          ),
        );
      },
    );
  }
}

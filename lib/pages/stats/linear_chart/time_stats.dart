import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../enums/day_time.dart';
import '../../../models/day_time_model.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_manager.dart';
import '../stats_page.dart';
import 'legend_key.dart';
import 'linear_chart.dart';

class TimeStats extends StatefulWidget {
  const TimeStats({
    super.key,
  });

  @override
  State<TimeStats> createState() => _TimeStatsState();
}

class _TimeStatsState extends State<TimeStats> {
  late final Future<List<StatsModel>> _statsFuture;

  @override
  void initState() {
    _statsFuture = DatabaseManager().getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<StatsModel>>(
      future: _statsFuture,
      builder: (context, snapshot) {
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

        if (snapshot.hasData) {
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

          final values = dayTimesTotals.values;
          final totalEntries = values.fold(
              0, (previousValue, element) => previousValue + element);

          List<Color> colors = [
            Colors.orange,
            Colors.purple,
            Colors.deepOrange,
            Colors.yellow
          ];

          for (int i = 0; i < DayTime.values.length; i++) {
            final e = dayTimesTotals.entries;
            dayTimes.add(
              DayTimeModel(
                  time: e.elementAt(i).key,
                  percent: e.elementAt(i).value / totalEntries,
                  color: colors[i]),
            );
          }
        }

        final size = MediaQuery.of(context).size;

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your preferred meditation time',
                style: Theme.of(context).textTheme.bodySmall,
              ).animate().fadeIn(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(
                        dayTimes.length,
                        (index) => LegendKey(
                              text: dayTimes[index].time.toText(),
                              color: dayTimes[index].color,
                              percent: dayTimes[index].percent,
                            ))),
              ),
              LinearChart(
                dayTimes: dayTimes,
              ),
            ],
          ),
        );
      },
    );
  }
}

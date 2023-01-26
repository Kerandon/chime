import 'package:chime/pages/stats/bar_chart_history.dart';
import 'package:chime/pages/stats/streak_stats_box.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {

  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notifier = ref.read(stateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.15,
              color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.15,
                  ),
                  const StreakStatsBox(),
                  const StreakStatsBox(),
                  SizedBox(
                    width: size.width * 0.15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.40,
              child:
              _toggle ?
              BarChartHistory(key: UniqueKey()) :
              BarChartHistory(key: UniqueKey())

            ),

            SizedBox(
            child: Row(
            children: [
    ElevatedButton(
    onPressed: () {
      _toggle = !_toggle;
      setState(() {

      });
    notifier.setBarChartTimePeriod(TimePeriod.monthly);
    DatabaseManager().getStats(TimePeriod.monthly);
    },
    child: Text('Month!!')),
    ElevatedButton(
    onPressed: () {
      _toggle = !_toggle;
      setState(() {

      });
    notifier.setBarChartTimePeriod(TimePeriod.week);
    DatabaseManager().getStats(TimePeriod.week);
    },
    child: Text('Week')),


          ],),)],
        ),
      ),
    );
  }
}

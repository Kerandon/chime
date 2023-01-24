import 'package:chime/pages/stats/bar_chart_history.dart';
import 'package:chime/pages/stats/streak_stats_box.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.20,
              color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: size.width * 0.15,),
                  StreakStatsBox(),
                  StreakStatsBox(),
                  SizedBox(width: size.width * 0.15,),
                ],
              ),
            ),
            Container(
              height: size.height * 0.30,
              child: BarChartHistory(),
            )
          ],
        ),
      ),
    );
  }
}




import 'package:chime/pages/stats/streak_stats.dart';
import 'package:chime/pages/stats/line_chart_total/line_chart_total_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import 'history_period_toggle.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  bool _toggle = false;

  void _toggleHistoryChart() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: SizedBox(
                  height: size.height * 0.20,
                  child: const StreakStats(),
                ),
              ),
              // SizedBox(
              //   height: size.height * 0.50,
              //   child: _toggle
              //       ? BarChartHistory(key: UniqueKey())
              //       : BarChartHistory(key: UniqueKey()),
              // ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.week,
                      toggleCallback: _toggleHistoryChart,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.fortnight,
                      toggleCallback: _toggleHistoryChart,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.year,
                      toggleCallback: _toggleHistoryChart,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.allTime,
                      toggleCallback: _toggleHistoryChart,
                    ),
                  ],
                ),
              ),
              const TotalTimeChart()
            ],
          ),
        ),
      ),
    );
  }
}

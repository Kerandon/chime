import 'package:chime/pages/stats/stats_divider.dart';
import 'package:chime/pages/stats/total_medition_time_title.dart';
import 'package:chime/pages/stats/streak/streak_stats.dart';
import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import 'bar_chart_history_main/bar_chart_history.dart';
import 'custom_line/animated_line_chart_main.dart';
import 'bar_chart_history_main/bar_chart_period_toggle.dart';
import 'linear_chart/time_stats.dart';
import 'meditation_history/meditation_history_page.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  final ScrollController _controller = ScrollController();

  bool _toggle = false;
  bool _notifyOnInit = false;

  void _toggleHistoryChart() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final notifier = ref.read(chartStateProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.setPageScrollOffset(offsetY: 0, size: size);
      if (!_notifyOnInit) {
        notifier.setLinearChartHasAnimated(false);
        _notifyOnInit = true;
      }
    });

    double pageWidthPadding = size.width * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        controller: _controller
          ..addListener(() {
            ref
                .read(chartStateProvider.notifier)
                .setPageScrollOffset(offsetY: _controller.offset, size: size);
          }),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageWidthPadding),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                    height: size.height * 0.40, child: const StreakStats()),
                const StatsDivider(),
                const SizedBox(
                  child: TotalMeditationTimeTitle(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.08),
                  child: SizedBox(
                      height: size.height * 0.45,
                      width: size.width,
                      child: _toggle
                          ? BarChartHistory(key: UniqueKey())
                          : BarChartHistory(key: UniqueKey())),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BarChartPeriodButton(
                          timePeriod: TimePeriod.week,
                          toggledCallback: _toggleHistoryChart,
                        ),
                        BarChartPeriodButton(
                          timePeriod: TimePeriod.fortnight,
                          toggledCallback: _toggleHistoryChart,
                        ),
                        BarChartPeriodButton(
                          timePeriod: TimePeriod.year,
                          toggledCallback: _toggleHistoryChart,
                        ),
                        BarChartPeriodButton(
                          timePeriod: TimePeriod.allTime,
                          toggledCallback: _toggleHistoryChart,
                        ),
                      ],
                    ),
                  ),
                ),
                const StatsDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01, bottom: size.height * 0.05),
                  child: SizedBox(
                      height: size.height * 0.60,
                      child: const AnimatedLineChartMain()),
                ),
                const StatsDivider(),
                SizedBox(
                  height: size.height * 0.30,
                  child: const TimeStats(),
                ),
                const StatsDivider(),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.10),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MeditationHistoryPage()));
                      },
                      child: Text(
                        'Clear meditation sessions',
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

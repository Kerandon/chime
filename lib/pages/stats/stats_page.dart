import 'package:chime/pages/stats/total_medition_time_title.dart';
import 'package:chime/pages/stats/streak/streak_stats.dart';
import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import 'bar_chart_history_main/bar_chart_history.dart';
import 'custom_line/animated_line_chart_main.dart';
import 'bar_chart_history_main/bar_chart_period_toggle.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  late final ScrollController _scrollController;

  double _scrollOffset = 0;


  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        _scrollOffset = _scrollController.offset;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.setPageScrollOffset(offsetY: _scrollOffset, size: size);

    });

    double pageWidthPadding = size.width * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageWidthPadding),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.20, child: const StreakStats()),
              const SizedBox(
                child: TotalMeditationTimeTitle(),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: SizedBox(
                  height: size.height * 0.45,
                  width: size.width,
                  child: state.toggleBarChart
                      ? BarChartHistory(key: UniqueKey())
                      : BarChartHistory(key: UniqueKey()),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    BarChartPeriodButton(
                      timePeriod: TimePeriod.week,
                    ),
                    BarChartPeriodButton(
                      timePeriod: TimePeriod.fortnight,
                    ),
                    BarChartPeriodButton(
                      timePeriod: TimePeriod.year,
                    ),
                    BarChartPeriodButton(
                      timePeriod: TimePeriod.allTime,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: SizedBox(
                    height: size.height * 0.60,
                    child: const AnimatedLineChartMain()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

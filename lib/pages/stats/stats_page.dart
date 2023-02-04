import 'package:chime/pages/stats/stats_title.dart';
import 'package:chime/pages/stats/streak_stats.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import 'bar_chart_history_main/bar_chart_history.dart';
import 'custom_line/animated_line_chart_main.dart';
import 'history_period_toggle.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  // bool _toggle = false;
  //
  // void _toggleHistoryChart() {
  //   setState(() {
  //     _toggle = !_toggle;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    double pageWidthPadding = size.width * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Stats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageWidthPadding),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.03),
                child: SizedBox(
                  height: size.height * 0.28,
                  child: const StreakStats(),
                ),
              ),

              SizedBox(
                height: size.height * 0.42,
                width: size.width,
                child: state.toggleBarChart
                    ? BarChartHistory(key: UniqueKey())
                    : BarChartHistory(key: UniqueKey()),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.week,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.fortnight,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.year,
                    ),
                    HistoryPeriodToggle(
                      timePeriod: TimePeriod.allTime,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: size.height * 0.60,
                  child: const AnimatedLineChartMain())
            ],
          ),
        ),
      ),
    );
  }
}
//
// class ChartTitle extends StatelessWidget {
//   const ChartTitle({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String totalText = calculateTotalMeditationTime(snapshot.data!, state);
//     String periodText = " in total";
//     if (snapshot.data!.isNotEmpty) {
//       TimePeriod? period = snapshot.data?.first.timePeriod;
//       switch (period!) {
//         case TimePeriod.week:
//           periodText = ' over the last week';
//           break;
//         case TimePeriod.fortnight:
//           periodText = ' over the last fortnight';
//           break;
//         case TimePeriod.year:
//           periodText = ' over the last year';
//           break;
//         case TimePeriod.allTime:
//           ' in total';
//           break;
//       }
//     }
//
//     return SizedBox(
//       child: RichText(
//         text: TextSpan(
//           text: 'You have meditated for ',
//           style: Theme
//               .of(context)
//               .textTheme
//               .bodySmall!
//               .copyWith(fontWeight: FontWeight.w300),
//           children: [
//             TextSpan(
//               text: totalText,
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .bodySmall!
//                   .copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: Theme
//                       .of(context)
//                       .primaryColor),
//             ),
//             TextSpan(
//               text: periodText,
//               style:
//               Theme
//                   .of(context)
//                   .textTheme
//                   .bodySmall!
//                   .copyWith(
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

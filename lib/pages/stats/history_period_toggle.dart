import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../configs/app_colors.dart';
import '../../enums/time_period.dart';
import '../../state/app_state.dart';

class HistoryPeriodToggle extends ConsumerWidget {
  const HistoryPeriodToggle(
      {Key? key,
      required this.timePeriod})
      : super(key: key);
  final TimePeriod timePeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state =  ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);
    return SizedBox(
      height: size.height * 0.05,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.01),
        child: OutlinedButton(
          onPressed: state.barChartHasData ? () {
            notifier.setBarChartToggle();
            notifier.setBarChartTimePeriod(timePeriod);
          } : null,
          style: OutlinedButton.styleFrom(
              side: BorderSide(
            color: state.barChartTimePeriod == timePeriod && state.barChartHasData ? Theme.of(context).primaryColor
                : AppColors.grey,
          )),
          child: Text(
            timePeriod.toText(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: state.barChartTimePeriod == timePeriod && state.barChartHasData ?
                  Theme.of(context).primaryColor : AppColors.grey,
            )
          ),
        ),
      ),
    );
  }
}

import 'package:chime/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_colors.dart';
import '../../../enums/time_period.dart';

class BarChartPeriodButton extends ConsumerWidget {
  const BarChartPeriodButton({
    Key? key,
    required this.timePeriod,
    required this.toggledCallback,
  }) : super(key: key);
  final TimePeriod timePeriod;
  final VoidCallback toggledCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);
    return Padding(
      padding: EdgeInsets.all(size.width * 0.01),
      child: OutlinedButton(
        onPressed: () {
                toggledCallback.call();
                notifier.setBarChartTimePeriod(timePeriod);
              },
        style: OutlinedButton.styleFrom(
            side: BorderSide(
          color: state.barChartTimePeriod == timePeriod ?
          Theme.of(context).primaryColor
              : AppColors.grey,
        )),
        child: Text(timePeriod.toText(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: state.barChartTimePeriod == timePeriod &&
                          state.barChartStats.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                      .secondaryHeaderColor
                )),
      ),
    ).animate().scaleXY(begin: 0.90).fadeIn();
  }
}

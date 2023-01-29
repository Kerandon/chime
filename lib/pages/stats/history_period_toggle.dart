import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../configs/app_colors.dart';
import '../../enums/time_period.dart';
import '../../state/app_state.dart';

class HistoryPeriodToggle extends ConsumerWidget {
  const HistoryPeriodToggle(
      {Key? key,
      required this.timePeriod,
      required this.toggleCallback,})
      : super(key: key);
  final VoidCallback toggleCallback;
  final TimePeriod timePeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state =  ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return Padding(
      padding: EdgeInsets.all(size.width * 0.01),
      child: OutlinedButton(
        onPressed: () {
          toggleCallback.call();
          notifier.setBarChartTimePeriod(timePeriod);
        },
        style: OutlinedButton.styleFrom(
            side: BorderSide(
          color: state.barChartTimePeriod == timePeriod ? Theme.of(context).primaryColor
              : AppColors.grey,
        )),
        child: Text(
          timePeriod.toText(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: state.barChartTimePeriod == timePeriod ?
                Theme.of(context).primaryColor : AppColors.grey,
          )
        ),
      ),
    );
  }
}

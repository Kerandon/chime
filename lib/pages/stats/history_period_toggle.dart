
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/time_period.dart';
import '../../state/app_state.dart';

class HistoryPeriodToggle extends ConsumerWidget {
  const HistoryPeriodToggle(
      {Key? key, required this.timePeriod, required this.toggleCallback})
      : super(key: key);
  final VoidCallback toggleCallback;
  final TimePeriod timePeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(stateProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
          onPressed: () {
            toggleCallback.call();
            notifier.setBarChartTimePeriod(timePeriod);
          },
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
              )),
          child: Text(
            timePeriod.toText(),
            style: Theme.of(context).textTheme.bodySmall,
          )),
    );
  }
}

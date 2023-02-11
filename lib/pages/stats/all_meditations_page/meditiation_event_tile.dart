import 'package:chime/state/chart_state.dart';
import 'package:chime/utils/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/stats_model.dart';

class MeditationEventTile extends ConsumerWidget {
  const MeditationEventTile({
    super.key,
    required this.stat,
    required this.index,
  });

  final StatsModel stat;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    final formatter = DateFormat.yMMMMEEEEd();
    final formattedDate = formatter.format(stat.dateTime);

    final duration = stat.totalMeditationTime.formatToHourMin();

    return CheckboxListTile(
        title: RichText(
          text: TextSpan(
            text: duration,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: ' on $formattedDate',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        value: state.selectedMeditationEvents.containsKey(index),
        onChanged: (value) {
          if (value == true) {
            notifier.selectMeditationEvents(items: {index: stat.dateTime});
          } else {
            notifier.selectMeditationEvents(
                items: {index: stat.dateTime}, unselect: true);
          }
        });
  }
}

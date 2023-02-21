import 'package:chime/state/chart_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
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


    final formatterDate = DateFormat.yMMMMEEEEd();
    final formatterTime = DateFormat.jm();
    final formattedDate = '${formatterTime.format(stat.dateTime)} on ${formatterDate.format(stat.dateTime)}';

    final duration = 'Meditated for ${stat.totalMeditationTime.formatToHourMin()}';

    return CheckboxListTile(

        title: RichText(
          text: TextSpan(
            text: duration,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(formattedDate),
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

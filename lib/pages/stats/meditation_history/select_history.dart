import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/stats_model.dart';
import '../../../state/chart_state.dart';
import 'meditation_history_page.dart';

class SelectHistory extends ConsumerWidget {
  const SelectHistory({
    super.key,
    required this.stats,
  });

  final List<StatsModel> stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    Map<int, DateTime> items = {};
    for (int i = 0; i < stats.length; i++) {
      items.addAll({i: stats[i].dateTime});
    }

    return Padding(
      padding: EdgeInsets.all(
        size.width * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: state.selectedMeditationEvents.isEmpty &&
                            stats.isNotEmpty
                            ? Theme
                            .of(context)
                            .primaryColor
                            : Theme
                            .of(context)
                            .secondaryHeaderColor,),),
                onPressed: () {
                  notifier.selectMeditationEvents(items: items);
                },
                child: Text(
                  'Select all',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                      color: state.selectedMeditationEvents.isEmpty &&
                          stats.isNotEmpty
                          ? Theme
                          .of(context)
                          .primaryColor
                          : Theme
                          .of(context)
                          .secondaryHeaderColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: state.selectedMeditationEvents.isNotEmpty
                                ? Theme
                                .of(context)
                                .primaryColor
                                : Theme
                                .of(context)
                                .secondaryHeaderColor)),
                    onPressed: state.selectedMeditationEvents.isNotEmpty
                        ? () {
                      notifier.selectMeditationEvents(
                          items: items, unselect: true);
                    }
                        : null,
                    child: Text('Unselect',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                            color: state.selectedMeditationEvents.isNotEmpty
                                ? Theme
                                .of(context)
                                .primaryColor
                                : Theme
                                .of(context)
                                .secondaryHeaderColor))),
              ),
            ],
          ),
          Row(
            children: [
              if (state.selectedMeditationEvents.isNotEmpty) IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text(
                                  'Remove selected meditation records?\n', textAlign: TextAlign.center,),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: [
                                OutlinedButton(

                                    onPressed: () async {



                                      List<DateTime> dateTimes = [];
                                      for (var i in state.selectedMeditationEvents.values) {
                                        dateTimes.add(i);
                                      }


                                      notifier.selectMeditationEvents(
                                          items: items, unselect: true);

                                      await DatabaseManager()
                                          .removeStats(dateTimes);


                                      Navigator.of(context, rootNavigator: true).pop('dialog');

                                      Navigator.maybePop(context).then((value) => Navigator.push(context,
                                         MaterialPageRoute(builder: (context) => const MeditationHistoryPage())
                                      ));
                                    },
                                    child: Text('Yes')),
                               OutlinedButton(
                                    onPressed: () async {
                                      await Navigator.of(context)
                                          .maybePop();
                                    },
                                    child: Text('Cancel'))
                              ],
                            ));
                  },
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: state.selectedMeditationEvents.isEmpty
                        ? Theme
                        .of(context)
                        .secondaryHeaderColor
                        : Colors.red,
                  )) else const SizedBox.shrink(),
              state.selectedMeditationEvents.isNotEmpty
                  ? Text(
                '(${state.selectedMeditationEvents.length.toString()})',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall,
              )
                  : const SizedBox.shrink(),
            ],
          )
        ],
      ),
    );
  }
}

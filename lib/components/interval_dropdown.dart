import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../state/state_manager.dart';

class IntervalDropdown extends ConsumerWidget {
  const IntervalDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    Set<DropdownMenuItem<int>> items = {};
    int? selectedValue = 1;

    for (var e in state.intervalTimes) {
      int totalTime = state.totalTime;

      items.add(
        DropdownMenuItem<int>(
          value: e,
          child: SizedBox(
            width: size.width * 0.60,
            child: Center(
              child: Text(
                e == totalTime
                    ? 'On time up only'
                    : e == 1
                        ? '$e minute'
                        : '$e minutes',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      );
    }

    selectedValue = state.intervalTime;
    if (items.every((element) => element.value != selectedValue) &&
        items.isNotEmpty) {
      selectedValue = items.first.value;
    }

    return SizedBox(
      height: size.height * 0.05,
      width: size.width * 0.70,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.005),
            child: Text(
              'Play a ${state.soundSelected.name} every',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
            ),
          ),
          items.isEmpty
              ? const SizedBox()
              : DropdownButton<int>(
                dropdownColor: Colors.black,
                value: selectedValue,
                iconSize: 0,
                items: items.toList(),
                onChanged: (Object? value) {
                  notifier.setIntervalTime(value as int);
                },
              ),
        ],
      ),
    );
  }
}

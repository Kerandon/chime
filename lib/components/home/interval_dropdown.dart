import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/state_manager.dart';
import '../../utils/constants.dart';

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
            width: size.width * kHomePageLineWidth,
            child: Center(
              child: Text(
                e == totalTime
                    ? kOnTimeUpOnlyText
                    : e == 1
                        ? '$e minute'
                        : '$e minutes',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
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

    bool showOnTimeUpTitleText = false;
    if (selectedValue == state.totalTime) {
      showOnTimeUpTitleText = true;
    }

    return SizedBox(
      height: size.height * 0.05,
      width: size.width * 0.70,
      child: Column(
        children: [
          Text(
            showOnTimeUpTitleText
                ? 'Play a ${state.soundSelected.name}'
                : 'Play a ${state.soundSelected.name} every',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          items.isEmpty
              ? const SizedBox.shrink()
              : DropdownButton<int>(
                  underline: Container(
                    height: kHomePageLineThickness,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadius),
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

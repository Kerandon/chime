import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../state/app_state.dart';
import '../../../configs/constants.dart';

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

    for (var e in state.bellIntervalMenuSelection) {
      int totalTime = state.totalTimeMinutes;

      items.add(
        DropdownMenuItem<int>(
          value: e,
          child: SizedBox(
            width: size.width * kHomePageLineWidth / 1.6,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bell,
                  ),
                  SizedBox(width: size.width * 0.03,),
                  Text(
                    e == totalTime
                        ? kOnTimeUpOnlyText
                        : e == 1
                            ? 'every ${e}min'
                            : 'every ${e}min',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    selectedValue = state.bellIntervalTimeSelected;
    if (items.every((element) => element.value != selectedValue) &&
        items.isNotEmpty) {
      selectedValue = items.first.value;
    }

    return Align(
      alignment: Alignment(0, 1),
      child: SizedBox(
        height: size.height * 0.15,
        width: size.width * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            items.isEmpty
                ? const SizedBox.shrink()
                : DropdownButton<int>(
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(overflow: TextOverflow.fade),
                    isDense: true,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    value: selectedValue,
                    iconSize: 0,
                    items: items.toList(),
                    onChanged: (Object? value) {
                      notifier.setBellIntervalTime(value as int);
                    },
              underline: const SizedBox.shrink(),
                  ),
          ],
        ),
      ),
    );
  }
}

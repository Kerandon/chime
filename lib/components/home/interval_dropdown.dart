import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../pages/setup/meditation_bells_page.dart';
import '../../state/app_state.dart';
import '../../configs/constants.dart';

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
            width: size.width * kHomePageLineWidth / 2,
            child: Center(
              child: Text(
                e == totalTime
                    ? kOnTimeUpOnlyText
                    : e == 1
                        ? '$e minute'
                        : '$e minutes',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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

    bool showOnTimeUpTitleText = false;
    if (selectedValue == state.totalTimeMinutes) {
      showOnTimeUpTitleText = true;
    }

    return SizedBox(
      height: size.height * 0.05,
      width: size.width * 0.60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MeditationBellsPage()));
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.01),
              child: RichText(
                text: TextSpan(
                  text: 'Play a',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                  children: [
                    TextSpan(
                      text: ' ${state.bellSelected.name}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: showOnTimeUpTitleText ? '' : ' every',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color:Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          items.isEmpty
              ? const SizedBox.shrink()
              : DropdownButton<int>(
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor
            ),
                  isDense: true,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  dropdownColor: Theme.of(context).dialogBackgroundColor,
                  value: selectedValue,
                  iconSize: 0,
                  items: items.toList(),
                  onChanged: (Object? value) {
                    notifier.setBellIntervalTime(value as int);
                  },
                ),
        ],
      ),
    );
  }
}

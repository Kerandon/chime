import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../state/app_state.dart';

class CustomNumberPicker extends ConsumerWidget {
  const CustomNumberPicker({
    super.key,
    required this.alignment,
    required this.text,
  });

  final MainAxisAlignment alignment;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    int totalTime = state.totalTimeMinutes;
    int value = 0;
    if (text == 'M') {
      value = totalTime % 60;
    } else {
      value = totalTime ~/ 60;
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          NumberPicker(
            textStyle: Theme.of(context).textTheme.displaySmall,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500
            ),
            itemWidth: size.width * 0.16,
            itemHeight: size.height * 0.08,
            minValue: 0,
            maxValue: text == 'M' ? 59 : 23,
            value: value,
            onChanged: (int value) {
              if (text == 'M') {
                notifier.setTotalTime(minutes: value);
              } else {
                notifier.setTotalTime(hours: value);
              }
            },
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

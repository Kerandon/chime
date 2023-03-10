import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../configs/constants.dart';
import '../../../../state/app_state.dart';

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
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);

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
            textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 15, color: Theme.of(context).secondaryHeaderColor),
            selectedTextStyle: Theme.of(context).textTheme.displaySmall,
            itemWidth: size.width * 0.15,
            itemHeight: size.height * 0.06,
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
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}

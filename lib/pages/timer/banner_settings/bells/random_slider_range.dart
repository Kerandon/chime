import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../state/app_state.dart';
import '../../../../state/audio_state.dart';

class RandomSliderRange extends ConsumerStatefulWidget {
  const RandomSliderRange({
    super.key,
  });

  @override
  ConsumerState<RandomSliderRange> createState() => _RandomSliderRangeState();
}

class _RandomSliderRangeState extends ConsumerState<RandomSliderRange> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    double value = 1;

    double max = appState.totalTimeMinutes.toDouble();
    value = audioState.maxRandomBell;
    if (!appState.openSession) {


      if (max >= 60) {
        max = 60;
      }
      if (value > max) {
        value = max;
      }
    } else {
      max = 60;
    }

    final num = '${(value).toInt()}m';
    return SizedBox(
      width: size.width * 0.60,
      height: size.height * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Center(
            child: Text(num),
          )),
          Expanded(
            flex: 6,
            child: Slider(
              min: 1,
              max: max,
              value: value,
              onChanged: (value) {
                audioNotifier.setMaxRandomRange(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

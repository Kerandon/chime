import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../state/app_state.dart';
import '../../../../state/audio_state.dart';

class RandomSliderRange extends ConsumerWidget {
  const RandomSliderRange({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    String num =
        '${audioState.maxRandomBell > appState.totalTimeMinutes.toInt() ? appState.totalTimeMinutes.toInt() : audioState.maxRandomBell.toInt()}m';

    return SizedBox(
      width: size.width * 0.65,
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
              max: appState.totalTimeMinutes.toDouble(),
              value: audioState.maxRandomBell >
                      appState.totalTimeMinutes.toDouble()
                  ? appState.totalTimeMinutes.toDouble()
                  : audioState.maxRandomBell,
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

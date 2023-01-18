
import 'package:chime/enums/focus_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../state/preferences_main.dart';
import '../../../state/app_state.dart';

class TimeAdjustmentIcons extends ConsumerWidget {
  const TimeAdjustmentIcons({
    super.key,
  });

  //final FocusNode _focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            notifier.setTimerFocusState(FocusState.unFocus);
            //_focusNode.unfocus();
            notifier.incrementTotalTime();
            if (state.totalTimeMinutes < 9999) {
              await PreferencesMain.setPreferences(
                totalTime: state.totalTimeMinutes + 1,
              );
            }
          },
          icon: const Icon(
            Icons.add,
            size: 20,
          ),
        ),
        SizedBox(
          width: size.width * 0.05,
        ),
        IconButton(
          onPressed: () async {
            notifier.setTimerFocusState(FocusState.unFocus);
            notifier.decrementTotalTime();
            if (state.totalTimeMinutes > 0) {
              await PreferencesMain.setPreferences(
                totalTime: state.totalTimeMinutes - 1,
              );
            }
          },
          icon: const Icon(
            Icons.remove,
            size: 20,
          ),
        ),
      ],
    );
  }
}

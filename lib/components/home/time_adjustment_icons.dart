
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/preferences_manager.dart';
import '../../state/state_manager.dart';

class TimeAdjustmentIcons extends ConsumerWidget {
  const TimeAdjustmentIcons({
    super.key,
    required FocusNode focusNode,
  }) : _focusNode = focusNode;

  final FocusNode _focusNode;

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
            _focusNode.unfocus();
            notifier.incrementTotalTime();
            if (state.totalTime < 9999) {
              await PreferencesManager.setPreferences(
                time: state.totalTime + 1,
              );
            }
          },
          icon: const Icon(
            Icons.add,
            size: 25,
          ),
        ),
        SizedBox(
          width: size.width * 0.10,
        ),
        IconButton(
          onPressed: () async {
            _focusNode.unfocus();
            notifier.decrementTotalTime();
            if (state.totalTime > 0) {
              await PreferencesManager.setPreferences(
                time: state.totalTime - 1,
              );
            }
          },
          icon: const Icon(
            Icons.remove,
            size: 25,
          ),
        ),
      ],
    );
  }
}

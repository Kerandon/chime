import 'package:chime/configs/constants.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../animation/pop_animation.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';

class StopButton extends ConsumerWidget {
  const StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return PopAnimation(
      animate: state.sessionState == SessionState.countdown ||
          state.sessionState == SessionState.inProgress,
      reset: state.sessionState == SessionState.notStarted,
      duration: kHomePageAnimationDuration,
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500)),
              side: BorderSide.none,
              backgroundColor: Theme.of(context).splashColor.withOpacity(0.10),
            ),
            onPressed: () {

              int elapsed = 0;
              if (!state.openSession) {
                elapsed = (state.totalTimeMinutes) -
                    (state.millisecondsRemaining / 60000).round();
                if (elapsed >= 1) {}
              }
              if (state.openSession) {
                elapsed = (state.millisecondsElapsed / 60000).round();
              }
              if (elapsed >= 1) {
                DatabaseManager().insertIntoStats(
                    dateTime: DateTime.now(), minutes: elapsed);
              }

              notifier.setSessionState(SessionState.notStarted);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              // notifier.resetSession();

              });
            },
            icon: const Icon(Icons.stop_outlined)),
      ),
    );
  }
}

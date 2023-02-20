import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../animation/pop_in_animation.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';

class StopButton extends ConsumerWidget {
  const StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return PopAnimation(
      animate: state.sessionState == SessionState.countdown,
      reset: state.sessionState == SessionState.notStarted,
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
             // notifier.setSessionStopped(true);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                notifier.setSessionState(SessionState.notStarted);
                notifier.resetSession();
              });
            },
            icon: Icon(Icons.stop_outlined)),
      ),
    );
  }
}

import 'package:chime/configs/constants.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../animation/pop_animation.dart';
import '../../audio/audio_manager_new.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';
import '../completion_page/completion_page.dart';

class StopButton extends ConsumerWidget {
  const StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    return PopAnimation(
      animate: appState.sessionState == SessionState.countdown ||
          appState.sessionState == SessionState.inProgress,
      reset: appState.sessionState == SessionState.notStarted,
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
              AudioManagerNew().stopAmbience();
              if(appState.sessionState == SessionState.countdown){
                appNotifier.setSessionState(SessionState.notStarted);
              }else {
                int elapsed = 0;
                if (!appState.openSession) {
                  elapsed = (appState.totalTimeMinutes) -
                      (appState.millisecondsRemaining / 60000).round();
                }
                if (appState.openSession) {
                  elapsed = (appState.millisecondsElapsed / 60000).round();
                }
                if (elapsed >= 1 ||
                    appState.sessionState == SessionState.countdown) {
                  DatabaseManager().insertIntoStats(
                      dateTime: DateTime.now(), minutes: elapsed);
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(
                        context: context,
                        builder: (context) => const CompletionPage())
                        .then((value) async {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        appNotifier.setSessionState(SessionState.notStarted);
                        appNotifier.resetSession();
                      });
                    });

                    appNotifier.setSessionState(SessionState.ended);
                  });
                } else {
                  appNotifier.setSessionState(SessionState.notStarted);
                }
              }
            },
            icon: const Icon(Icons.stop_outlined)),
      ),
    );
  }
}

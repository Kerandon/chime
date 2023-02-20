import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../animation/bounce_animation.dart';
import '../../../app_components/custom_ink_splash.dart';
import '../../../app_components/lotus_icon.dart';
import '../../../configs/constants.dart';
import '../../../enums/session_state.dart';
import '../../../state/app_state.dart';
import 'countdown_animation/count_down_animation.dart';

class CenterButton extends ConsumerWidget {
  const CenterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);

    Widget button = setButtonIcon(context: context, state: state);

    final notifier = ref.read(stateProvider.notifier);
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: size.width * 0.20,
            height: size.width * 0.20,
            child: Material(
              child: GestureDetector(
                onTap: state.sessionState == SessionState.countdown
                    ? null
                    : () {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          notifier.setAnimateSplash(true);
                        });
                        if (state.sessionState == SessionState.notStarted) {
                          if (state.countdownIsOn) {
                            notifier.setSessionState(SessionState.countdown);
                          }else{
                            notifier.setSessionState(SessionState.inProgress);
                          }
                        }

                        if (state.sessionState == SessionState.inProgress) {
                          notifier.setSessionState(SessionState.paused);
                        }
                        if (state.sessionState == SessionState.paused) {
                          notifier.setPausedTimeMillisecondsRemaining();
                          notifier.setSessionState(SessionState.inProgress);
                        }
                      },
                child: BounceAnimation(
                  animate: state.sessionState == SessionState.inProgress,
                  stop: state.sessionState != SessionState.inProgress,
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 800,
                    ),
                    child: button,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              width: size.width * 0.20,
              height: size.width * 0.20,
              child: const CustomInkSplash()),
        ],
      ),
    );
  }
}

Widget setButtonIcon({required BuildContext context, required AppState state}) {
  if (state.sessionState == SessionState.notStarted) {
    return Icon(
      Icons.play_arrow_outlined,
      size: kStartButtonIconSize,
      color: Theme.of(context).primaryColor,
    );
  }
  if (state.sessionState == SessionState.countdown) {
    final maxLoops = state.totalCountdownTime ~/ 5;

    return CountdownAnimation(
      animate: true,
      maxLoops: maxLoops,
    );
  }
  if (state.sessionState == SessionState.inProgress) {
    return const LotusIcon();
  }
  if (state.sessionState == SessionState.paused) {
    return Icon(
      Icons.pause,
      size: kStartButtonIconSize,
      color: Theme.of(context).primaryColor,
    );
  } else {
    return const SizedBox.shrink();
  }
}

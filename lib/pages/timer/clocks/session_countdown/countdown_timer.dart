import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/constants.dart';
import '../../../../enums/session_state.dart';
import '../../../../state/app_state.dart';
import 'colon.dart';
import 'number_box.dart';

class CountDownTimer extends ConsumerWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    final state = ref.watch(stateProvider);

    int minutes = 0;
    int seconds = 0;

    if (state.sessionState == SessionState.countdown) {
      seconds = (state.currentCountdownTime);
    }
    return SizedBox(
      height: size.height * 0.20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.sessionState == SessionState.countdown) ...[
            if (state.totalCountdownTime == 60) ...[
              NumberBox(minutes),
              const Colon(),
            ],
            NumberBox(seconds),
          ],
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/constants.dart';
import '../../../../state/app_state.dart';

class Countdown extends ConsumerWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    final state = ref.watch(stateProvider);
    int seconds = state.currentCountdownTime;
    return SizedBox(
      height: size.height * kClocksHeight,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.30),
            child: Text(
              seconds.toString().padLeft(2, '0'),
              style: Theme
                  .of(context)
                  .textTheme
                  .displayLarge,
              textAlign: TextAlign.right,
            ),
          ),
          Align(
              alignment: const Alignment(0, 0.60),
              child: Text(kSessionWillBeginShortly, style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,)
          )
        ],
      ).animate()
          .fadeIn(duration: 300.milliseconds)
          .fadeOut(
          duration: 100.milliseconds,
          delay: (state.totalCountdownTime).seconds),
    );
  }
}

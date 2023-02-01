import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/constants.dart';
import '../../../state/app_state.dart';

class Countdown extends ConsumerWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    print('countdown time is ${state.currentCountdownTime}');
    int seconds = state.currentCountdownTime;
    return SizedBox(
      height: size.height * kClocksHeight,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: size.width * 0.18,
              child: Text( seconds == 0 ? '' :
                seconds.toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.right,
              )                  .animate()
                  .fadeIn(duration: 500.milliseconds)
                  .fadeOut(
                  duration: 500.milliseconds,
                  delay: (state.totalCountdownTime).seconds)
            )
          ),
          Align(
              alignment: Alignment(0, 0.80),
              child: Text('Session will begin shortly...')
                  .animate()
                  .fadeIn()
                  .fadeOut(delay: (state.totalCountdownTime).seconds)
        )
        ],
      ),
    );
  }
}

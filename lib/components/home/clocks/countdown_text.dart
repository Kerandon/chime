import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chime/animation/fade_in_animation.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

import '../../../configs/app_colors.dart';

class CountdownText extends ConsumerStatefulWidget {
  const CountdownText({
    super.key,
  });

  @override
  ConsumerState<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends ConsumerState<CountdownText> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    int countdown = state.currentCountdownTime;
    if (countdown > state.totalCountdownTime) {
      countdown = state.totalCountdownTime;
    }

    String countdownText = countdown.toString();

    return SizedBox(
      height: size.height * 0.10,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 0),
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    buildFadeAnimatedText(
                        context: context,
                        text: 'Session will start shortly...',
                        duration: state.totalCountdownTime),
                  ]),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.02),
            child: countdown == 0
                ? SizedBox.shrink()
                : FadeInAnimation(
              durationMilliseconds: 500,
                  child: Text(
                      countdownText,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.lightGrey.withOpacity(0.40)),
                    ),
                ),
          )),
        ],
      ),
    );
  }

  FadeAnimatedText buildFadeAnimatedText(
      {required BuildContext context,
      required String text,
      required int duration}) {
    return FadeAnimatedText(
      text,
      textStyle: Theme.of(context).textTheme.displayMedium,
      textAlign: TextAlign.center,
      duration: Duration(seconds: duration),
      fadeOutBegin: 0.80,
      fadeInEnd: 0.5,
    );
  }
}

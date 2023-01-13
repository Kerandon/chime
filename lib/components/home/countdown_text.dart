
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CountdownText extends StatelessWidget {
  const CountdownText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
        pause: const Duration(milliseconds: 600),
        isRepeatingAnimation: false,
        animatedTexts: [
          FadeAnimatedText('3',
              textStyle: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
              duration: const Duration(milliseconds: 1500),
              fadeOutBegin: 0.90,
              fadeInEnd: 0.7),
          FadeAnimatedText('2',
              textStyle: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
              duration: const Duration(milliseconds: 1500),
              fadeOutBegin: 0.90,
              fadeInEnd: 0.7),
          FadeAnimatedText('1',
              textStyle: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
              duration: const Duration(milliseconds: 1500),
              fadeOutBegin: 0.90,
              fadeInEnd: 0.7),
        ]);
  }
}

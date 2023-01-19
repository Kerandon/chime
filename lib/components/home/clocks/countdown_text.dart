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
          buildFadeAnimatedText(context: context, text: '3'),
          buildFadeAnimatedText(context: context, text: '2'),
          buildFadeAnimatedText(context: context, text: '1'),
        ]);
  }

  FadeAnimatedText buildFadeAnimatedText(
      {required BuildContext context, required String text}) {
    return FadeAnimatedText(
      text,
      textStyle: Theme.of(context).textTheme.displayLarge,
      duration: const Duration(milliseconds: 1500),
      fadeOutBegin: 0.90,
      fadeInEnd: 0.7,
    );
  }
}

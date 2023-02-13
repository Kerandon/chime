import 'package:chime/animation/fade_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../configs/constants.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * kSettingsHorizontalPageIndent / 2;
    final heightPadding = size.height * 0.02;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Guide'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widthPadding,
            heightPadding,
            widthPadding,
            heightPadding,
          ),
          child: Column(
            children: [
               Container(
                  height: size.height * 0.35,
                  width: size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    image: const DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage('assets/images/meditation.png'),
                    ),
                ),
              ).animate().fadeIn(duration: 1.seconds).scaleXY(begin: 0.98),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Text.rich(
                  TextSpan(
                    text: '\nStep 1',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).primaryColor),
                    children: [
                      TextSpan(
                          text: '\n\nPlace your attention on your breath',
                          style: Theme.of(context).textTheme.displaySmall,),
                      TextSpan(
                        text: '\n\nStep 2',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(

                            color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                          text:
                              '\n\nIf you find your mind has wandered, gently return your attention to your breath',
                          style: Theme.of(context).textTheme.displaySmall),
                      TextSpan(
                        text: '\n\nStep 3',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                          text: '\n\nRepeat\n\n',
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                )
              ).animate().slideY(begin: -0.01, duration: 1200.milliseconds).fadeIn(duration: 1200.milliseconds)
            ],
          ),
        ),
      ),
    );
  }
}

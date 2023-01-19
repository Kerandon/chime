import 'package:chime/animation/flip_animation.dart';
import 'package:chime/components/home/start_button/start_button.dart';
import 'package:chime/components/home/streak_counter.dart';
import 'package:flutter/material.dart';
import '../../animation/fade_in_animation.dart';
import 'ambience_display.dart';
import 'clocks/app_timer.dart';
import 'interval_dropdown.dart';

class HomePageContents extends StatefulWidget {
  const HomePageContents({
    super.key,
  });

  @override
  State<HomePageContents> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends State<HomePageContents> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AmbienceDisplay(),
                      StreakCounter(),
                    ],
                  )),
              const Expanded(
                  flex: 35, child: FadeInAnimation(child: AppTimer())),
              const Expanded(
                flex: 90,
                child: FlipAnimation(child: StartButton()),
              ),
              const Expanded(
                  flex: 30, child: FadeInAnimation(child: IntervalDropdown())),
            ],
          ),
        ],
      ),
    );
  }
}

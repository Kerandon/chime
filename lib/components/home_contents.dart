
import 'package:chime/components/sound_selection.dart';
import 'package:chime/components/start_button.dart';
import 'package:chime/components/streak_counter.dart';
import 'package:flutter/material.dart';

import 'app_timer.dart';
import 'interval_dropdown.dart';

class CountDownText extends StatelessWidget {
  const CountDownText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.90,
      child: Stack(
        children: [
          const StreakCounter(),
          Column(
            children: const [
              Expanded(flex: 15, child: SizedBox()),
              Expanded(flex: 120, child: AppTimer()),
              Expanded(flex: 5, child: SizedBox()),
              Expanded(flex: 40, child: IntervalDropdown()),
              Expanded(flex: 20, child: SoundSelection()),
              Expanded(
                flex: 80,
                child: StartButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

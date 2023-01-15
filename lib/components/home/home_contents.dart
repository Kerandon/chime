import 'package:chime/components/home/sound_selection.dart';
import 'package:chime/components/home/start_button.dart';
import 'package:chime/components/home/streak_counter.dart';
import 'package:flutter/material.dart';
import 'app_timer.dart';
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
            children: const [
              Expanded(flex: 15, child: StreakCounter()),
              Expanded(flex: 100, child: AppTimer()),
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

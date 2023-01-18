import 'package:chime/components/home/start_button/start_button.dart';
import 'package:chime/components/home/streak_counter.dart';
import 'package:flutter/material.dart';
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
                  flex: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AmbienceDisplay(),
                      StreakCounter(),
                    ],
                  )),


              const Expanded(flex: 40, child: AppTimer()),
              const Expanded(flex: 20, child: IntervalDropdown()),
              const Expanded(
                flex: 60,
                child: StartButton(),
              ),

             //  const Expanded(flex: 20, child: SoundSelection()),
             //  Expanded(
             //      flex: 30,
             //      child: Center(
             //        child: Container(
             //          width: size.width * 0.30,
             //          height: size.height * 0.06,
             //    decoration: BoxDecoration(
             //        border: Border.all(
             //          color: Theme.of(context).primaryColor
             //        ),
             //    ),
             //          child: Icon(Icons.play_arrow_outlined),
             //  ),
             //      ))

            ],
          ),
        ],
      ),
    );
  }
}

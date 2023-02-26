import 'package:chime/app_components/custom_animated_grid_box.dart';
import 'package:chime/pages/timer/start_button/custom_clocks/custom_clock_dash.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_slider_tile.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../../enums/clock_design.dart';
import '../../timer/start_button/custom_clocks/custom_clock_circle.dart';
import '../../timer/start_button/custom_clocks/custom_clock_clock.dart';
import '../../timer/start_button/custom_clocks/custom_clock_solid.dart';

class TimerDesignPage extends ConsumerWidget {
  const TimerDesignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Design'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * kPageIndentation,
            size.width * kPageIndentation, size.width * kPageIndentation, 0),
        child: Column(
          children: [
            CustomSwitchTile(
                title: 'Show timer',
                icon: FontAwesomeIcons.clock,
                value: state.showTimerDesign,
                onChanged: (value) => notifier.showTimerDesign(value)),
            Expanded(
              child: GridView.builder(
                  itemCount: TimerDesign.values.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final design = TimerDesign.values.elementAt(index);

                    CustomPainter? customPainter;

                    switch (design) {
                      case TimerDesign.solid:
                        customPainter = CustomClockSolid(
                          percentage: 0.75,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          dashColor: Theme.of(context).primaryColor,
                        );
                        break;
                      case TimerDesign.dash:
                        customPainter = CustomClockDash(
                          percentage: 0.75,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          dashColor: Theme.of(context).primaryColor,
                        );
                        break;
                      case TimerDesign.circle:
                        customPainter = CustomClockCircle(
                          percentage: 0.75,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          dashColor: Theme.of(context).primaryColor,
                        );
                        break;
                      case TimerDesign.clock:
                        customPainter = CustomClockClock(
                          percentage: 0.75,
                          fillColor: Theme.of(context).primaryColor,
                          borderColor: Theme.of(context).colorScheme.tertiary,
                          dashColor: Theme.of(context).colorScheme.tertiary,
                        );
                        break;
                    }

                    return CustomAnimatedGridBox(
                      labelText: design.name,
                      onPressed: () {
                        notifier.setTimerDesign(design);
                      },
                      isSelected: design == state.timerDesign,
                      contents: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Padding(
                            padding: EdgeInsets.all(size.width * 0.05),
                            child: CustomPaint(
                              painter: customPainter,
                            )),
                      ),
                      alignment: Alignment.center,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

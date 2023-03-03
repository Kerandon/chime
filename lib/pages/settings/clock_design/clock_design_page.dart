import 'package:chime/app_components/custom_animated_grid_box.dart';
import 'package:chime/pages/timer/start_button/custom_clocks/custom_clock_dash.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_slider_tile.dart';
import '../../../configs/constants.dart';
import '../../../enums/clock_design.dart';
import '../../timer/start_button/custom_clocks/custom_clock_circle.dart';
import '../../timer/start_button/custom_clocks/custom_clock_clock.dart';
import '../../timer/start_button/custom_clocks/custom_clock_solid.dart';

class TimerDesignPage extends ConsumerStatefulWidget {
  const TimerDesignPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerDesignPage> createState() => _TimerDesignPageState();
}

class _TimerDesignPageState extends ConsumerState<TimerDesignPage> with SingleTickerProviderStateMixin {

  late final AnimationController _controllerPercent;
  double _percent = 0.0;

  @override
  void initState() {
    _controllerPercent = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..addListener(() {
      _percent = _controllerPercent.value;
      setState(() {});
    });
    _controllerPercent.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerPercent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if(!state.showTimerDesign){
      _controllerPercent.stop();
    }
    if(state.showTimerDesign){
      _controllerPercent.repeat();
    }

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
                          percentage: _percent,
                          dashColor: primaryColor,
                          backgroundColor:
                              secondaryColor,
                        );
                        break;
                      case TimerDesign.dash:
                        customPainter = CustomClockDash(
                          percentage: _percent,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          dashColor: Theme.of(context).primaryColor,
                        );
                        break;
                      case TimerDesign.circle:
                        customPainter = CustomClockCircle(
                          percentage: _percent,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          circlesColor: Theme.of(context).primaryColor,
                        );
                        break;
                      case TimerDesign.clock:
                        customPainter = CustomClockClock(
                          percentage: _percent,
                          fillColor: Theme.of(context).primaryColor,
                          borderColor: Theme.of(context).colorScheme.tertiary,
                        );
                        break;
                    }

                    return CustomAnimatedGridBox(
                      labelText: design.name,
                      onPressed: state.showTimerDesign ? () {
                        notifier.setTimerDesign(design);
                      } : null,
                      isSelected: design == state.timerDesign && state.showTimerDesign,
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

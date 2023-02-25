import 'package:chime/app_components/custom_animated_grid_box.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import '../../../enums/clock_design.dart';
import '../../timer/start_button/custom_clocks/custom_clock_dash.dart';

class ClockDesignPage extends ConsumerWidget {
  const ClockDesignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock Design'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * kPageIndentation,
            size.width * kPageIndentation, size.width * kPageIndentation, 0),
        child: GridView.builder(
            itemCount: ClockDesign.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 1, mainAxisSpacing: 1, crossAxisCount: 2),
            itemBuilder: (context, index) {
              final design = ClockDesign.values.elementAt(index);
              return CustomAnimatedGridBox(
                labelText: design.name, onPressed: () {
                notifier.setClockDesign(design);
              },
                isSelected: design == state.clockDesign, contents: SizedBox(
                width: size.width,
                height: size.height,
                child:
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: CustomPaint(
              painter:
              CustomClockDash(percentage: 0.50, backgroundColor: Theme
                    .of(context)
                    .primaryColor, dashColor: Theme
                    .of(context)
                    .primaryColor),),
                  ),
              ));
            }
        ),
      ),
    );
  }
}

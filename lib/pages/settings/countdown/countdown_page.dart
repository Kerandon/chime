import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_slider_tile.dart';
import '../../../configs/constants.dart';
import '../../../data/bell_times.dart';
import '../warmup_countdown/countdown_checklist.dart';

class CountdownPage extends ConsumerWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warmup Countdown'),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * kPageIndentation),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSwitchTile(
                title: 'Turn on countdown',
                icon: Icons.timer_outlined,
                value: state.countdownIsOn,
                onChanged: (value) => notifier.setCountdownIsOn(value),
              ),
              ListView.builder(
                itemCount: countdownTimes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => CountdownChecklist(
                  countdownTime: countdownTimes[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

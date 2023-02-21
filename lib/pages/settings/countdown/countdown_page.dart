import 'package:chime/state/app_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../../data/countdown_times.dart';
import '../../../enums/prefs.dart';
import '../components/settings_title.dart';
import '../warmup_countdown/countdown_checklist.dart';

class CountdownPage extends ConsumerWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.timer_outlined), text: 'Warmup Countdown'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * kPageIndentation),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: SwitchListTile(
                    inactiveTrackColor: AppColors.grey,
                    inactiveThumbColor: AppColors.lightGrey,
                    title: const Text('Turn on countdown'),
                    value: state.countdownIsOn, onChanged: (value) async {
                      notifier.setCountdownIsOn(!state.countdownIsOn);

                      await DatabaseManager().insertIntoPrefs(k: Prefs.countdownIsOn.name, v: value);

                }),
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

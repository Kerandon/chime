import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/settings/settings_title.dart';
import '../components/settings/warmup_countdown/countdown_checklist.dart';
import '../configs/constants.dart';
import '../data/countdown_times.dart';

class CountdownPage extends ConsumerWidget {
  const CountdownPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        title: SettingsTitle(
            icon: Icon(Icons.timer_outlined), text: 'Warmup Timer'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * kSettingsListWidthIndentation),
        child: SingleChildScrollView(
          child: ListView.builder(
            itemCount: countdownTimes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                CountdownChecklist(countdownTime: countdownTimes[index],),
          ),
        ),
      ),
    );
  }
}

import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../state/app_state.dart';

class CountdownChecklist extends ConsumerWidget {
  const CountdownChecklist({
    required this.countdownTime,
    super.key,
  });

  final int countdownTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title = "";

    if (countdownTime == 0) {
      title = 'None';
    }
    if (countdownTime > 0 && countdownTime < 60) {
      title = '$countdownTime seconds';
    }
    if (countdownTime >= 60) {
      title = '${countdownTime ~/ 60} minutes';
    }

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return CheckboxListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: countdownTime == state.totalCountdownTime,
      onChanged: (value) {
        notifier.setTotalCountdownTime(countdownTime);
        PreferencesMain.setPreferences(countdownTime: countdownTime);
      },
    );
  }
}

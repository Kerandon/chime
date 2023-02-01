import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import '../../../data/countdown_times.dart';
import '../components/settings_title.dart';
import '../warmup_countdown/countdown_checklist.dart';

class CountdownPage extends ConsumerWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.timer_outlined), text: 'Warmup Countdown'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * kPageIndentation),
        child: SingleChildScrollView(
          child: ListView.builder(
            itemCount: countdownTimes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => CountdownChecklist(
              countdownTime: countdownTimes[index],
            ),
          ),
        ),
      ),
    );
  }
}

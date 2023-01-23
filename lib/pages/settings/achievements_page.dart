import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/app/confirmation_box.dart';
import '../../components/app/custom_outline_button.dart';
import '../../components/settings/settings_title.dart';
import '../../models/streak_model.dart';
import '../../state/app_state.dart';
import '../../state/preferences_streak.dart';
import '../../configs/constants.dart';

class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  bool _disableReset = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
          icon: Icon(Icons.bar_chart_outlined),
          text: 'Meditation Stats',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * kSettingsHorizontalPageIndent),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}

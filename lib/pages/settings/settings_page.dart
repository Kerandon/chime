import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/pages/meditation_bells_page.dart';
import 'package:chime/pages/countdown_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/app/lotus_icon.dart';
import '../components/settings/bell_on_start_tile.dart';
import '../components/settings/open_session_tile.dart';
import '../components/settings/settings_divider.dart';
import '../components/settings/settings_tile.dart';
import '../configs/constants.dart';
import 'achievements_page.dart';
import 'ambience_page.dart';
import 'guide_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingsTitleDivider(
              title: 'Session adjustments',
              hideDivider: true,
            ),
            const OpenSessionTile(),
            SettingsTile(
              icon: const Icon(
                Icons.audiotrack_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Bell',
              subTitle: state.bellSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MeditationBellsPage()));
              },
            ),
            const BellOnStartTile(),
            SettingsTile(
              icon: const Icon(
                Icons.piano_outlined,
                color: Colors.white,
              ),
              title: 'Ambience',
              subTitle: state.ambienceSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AmbiencePage()));
              },
            ),
            SettingsTile(
              icon: const Icon(
                Icons.timer_outlined,
                color: Colors.white,
              ),
              title: 'Warmup Countdown',
              subTitle: '${state.totalCountdownTime.toString()} seconds',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CountdownPage()));
              },
            ),
            const SettingsTitleDivider(title: 'Guidance & achievements'),
            SettingsTile(
              icon: const Icon(
                Icons.tips_and_updates_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Guide',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GuidePage()));
              },
            ),
            SettingsTile(
                faIcon: const FaIcon(
                  FontAwesomeIcons.award,
                  color: Colors.white,
                ),
                title: 'Achievements',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage()),
                  );
                }),
            SettingsTile(
                icon: const Icon(
                  Icons.question_mark_outlined,
                  color: Colors.white,
                ),
                title: 'FAQ',
                onPressed: () {}),
            const SettingsTitleDivider(
              title: 'Appearance',
            ),
            SettingsTile(
                icon: const Icon(
                  Icons.style_outlined,
                  color: Colors.white,
                ),
                title: 'Color theme',
                onPressed: () {}),
            SettingsTile(
                icon: const Icon(
                  Icons.layers_outlined,
                  color: Colors.white,
                ),
                title: 'Hide countdown clock',
                onPressed: () {}),
            const SettingsTitleDivider(),
            SettingsTile(
                icon: const Icon(
                  Icons.restart_alt_outlined,
                  color: Colors.white,
                ),
                title: 'Reset all settings',
                onPressed: () {}),
            SettingsTile(
                icon: const Icon(
                  Icons.info_outlined,
                  color: Colors.white,
                ),
                title: 'About',
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: kAppName,
                      applicationVersion: '1.0',
                      applicationIcon: const LotusIcon());
                }),
          ],
        ),
      ),
    );
  }
}

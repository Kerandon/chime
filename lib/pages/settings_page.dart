import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/pages/interval_bells_page.dart';
import 'package:chime/pages/countdown_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/app/lotus_icon.dart';
import '../components/settings/settings_tile.dart';
import '../configs/app_colors.dart';
import '../configs/constants.dart';
import '../data/countdown_times.dart';
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
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingsTitleDivider(title: 'Session adjustments', hideDivider: true,),
            SettingsTile(
              icon: const Icon(
                Icons.audiotrack_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Bell',
              subTitle: state.bellSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const IntervalBellsPage()));
              },
            ),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CountdownPage()));
                }),
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

class SettingsTitleDivider extends StatelessWidget {
  const SettingsTitleDivider({
    super.key,
    this.title,
    this.hideDivider = false,
  });

  final String? title;
  final bool hideDivider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        hideDivider ? SizedBox(height: size.height * 0.03,) : Divider(),
        Align(
          alignment: const Alignment(-0.90, 0),
          child: title == null
              ? const SizedBox.shrink()
              : Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppColors.lightGrey, fontSize: 12),
                ),
        ),
      ],
    );
  }
}

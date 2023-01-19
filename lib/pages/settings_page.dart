import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/pages/bells_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/app/lotus_icon.dart';
import '../components/settings/settings_tile.dart';
import '../configs/app_colors.dart';
import '../configs/constants.dart';
import 'achievements_page.dart';
import 'ambience_page.dart';
import 'meditation_guide_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.05, bottom: size.height * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    kAppName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: const LotusIcon(),
                  ),
                ],
              ),
            ),
            const SettingsTitleDivider(title: 'Session adjustments'),
            SettingsTile(
              icon: const Icon(
                Icons.audiotrack_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Bell',
              subTitle: state.bellSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const BellsPage()));
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
                subTitle: '${state.countDownTime.toString()} seconds',
                onPressed: () {}),
            const SettingsTitleDivider(title: 'Guidance & achievements'),
            SettingsTile(
              icon: const Icon(
                Icons.tips_and_updates_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Guide',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MeditationGuidePage()));
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
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
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

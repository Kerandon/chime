import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../animation/fade_in_animation.dart';
import '../components/app/confirmation_box.dart';
import '../components/app/custom_outline_button.dart';
import '../components/settings/settings_title.dart';
import '../models/streak_model.dart';
import '../state/app_state.dart';
import '../state/preferences_streak.dart';
import '../configs/constants.dart';

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * kSettingsHorizontalPageIndent),
          child: Column(
            children: [
              SettingsTitle(
                faIcon: FaIcon(
                  FontAwesomeIcons.award,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Your achievements',
              ),
              SizedBox(
                height: size.height * kSettingsImageHeight,
                child: FadeInAnimation(
                    child: Image.asset('assets/images/people/person_2.png')),
              ),
              FutureBuilder<StreakData>(
                  future: PreferencesStreak.getStreakData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.current == 0 &&
                          snapshot.data!.best == 0) {
                        _disableReset = true;
                      } else {
                        _disableReset = false;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {});
                        });
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          top: size.height * 0.06,
                          right: size.width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    buildTableCellLeft(
                                        context: context,
                                        text: '\nCurrent streak'),
                                    buildTableCellRight(
                                        context: context,
                                        text: '\n${snapshot.data!.current}\n\n')
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    buildTableCellLeft(
                                        context: context, text: 'Best streak'),
                                    buildTableCellRight(
                                        context: context,
                                        text: '${snapshot.data!.best}')
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.06),
                              child: SizedBox(
                                width: size.width * 0.60,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.10,
                                      bottom: size.height * 0.05),
                                  child: CustomOutlineButton(
                                      disable: _disableReset,
                                      text: 'Reset',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ConfirmationBox(
                                              text: 'Confirm reset?',
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .maybePop()
                                                    .then((value) =>
                                                        Navigator.of(context)
                                                            .maybePop());

                                                PreferencesStreak
                                                        .clearAllStreakData()
                                                    .then((value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Streak stats cleared'))));
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  ref
                                                      .read(stateProvider
                                                          .notifier)
                                                      .checkIfStatsUpdated(
                                                          true);
                                                });
                                              }),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

TableCell buildTableCellLeft(
    {required BuildContext context, required String text}) {
  return TableCell(
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}

TableCell buildTableCellRight(
    {required BuildContext context, required String text}) {
  return TableCell(
    child: Text(text,
        textAlign: TextAlign.end,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).primaryColor)),
  );
}

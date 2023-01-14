
import 'package:chime/models/streak_data.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/preferences_manager.dart';
import '../app/confirmation_box.dart';
import '../app/custom_outline_button.dart';

class StreakSettings extends ConsumerStatefulWidget {
  const StreakSettings({
    super.key,
  });

  @override
  ConsumerState<StreakSettings> createState() => _StreakSettingsState();
}

class _StreakSettingsState extends ConsumerState<StreakSettings> {

  bool _disableReset = true;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.award,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            '  Daily Streak',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
      content: SizedBox(
        height: size.height * 0.20,
        child: FutureBuilder<StreakData>(
            future: PreferencesManager.getStreakData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.current == 0 && snapshot.data!.best == 0) {
                  _disableReset = true;
                }else{
                  _disableReset = false;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                    });
                  });

                }
                return Column(
                  children: [
                    Table(
                      children: [
                        TableRow(children: [
                          buildTableCellLeft(
                              context: context, text: '\nCurrent'),
                          buildTableCellRight(
                              context: context,
                              text: '\n${snapshot.data!.current}\n\n')
                        ]),
                        TableRow(children: [
                          buildTableCellLeft(context: context, text: 'Best'),
                          buildTableCellRight(
                              context: context, text: '${snapshot.data!.best}')
                        ]),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: size.width * 0.60,
          child: CustomOutlineButton(
            disable: _disableReset,
            text: 'Reset',
            onPressed:  () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationBox(
                          text: 'Confirm reset?',
                          onPressed: () {
                            Navigator.of(context).maybePop().then((value) => Navigator.of(context).maybePop());

                            PreferencesManager.clearAllStreakData().then((value)
                            => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Streak stats cleared'))));
                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              ref.read(stateProvider.notifier).checkIfStatsUpdated(true);
                            });

                          }),
                    );
                  }
          ),
        ),
      ],
    );
  }

  TableCell buildTableCellRight(
      {required BuildContext context, required String text}) {
    return TableCell(
        child: Text(
      text,
      textAlign: TextAlign.end,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontSize: 20, color: Colors.black),
    ));
  }

  TableCell buildTableCellLeft(
      {required BuildContext context, required String text}) {
    return TableCell(
        child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../state/app_state.dart';

class OpenSessionTile extends ConsumerWidget {
  const OpenSessionTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return SwitchListTile(
      inactiveTrackColor: Theme.of(context).disabledColor,
      inactiveThumbColor: Theme.of(context).disabledColor,
      title: Row(
        children: [
           FaIcon(

              state.openSession ? FontAwesomeIcons.infinity : Icons.timer_outlined

          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.06),
            child: Text('Open session (no timer)',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
      value: state.openSession,
      onChanged: (value) {
        notifier.setOpenSession();
      },
    );
  }
}
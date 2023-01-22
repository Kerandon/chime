
import 'package:chime/enums/bell.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/app_colors.dart';
import '../../state/app_state.dart';

class BellOnStartTile extends ConsumerWidget {
  const BellOnStartTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return SwitchListTile(
      inactiveTrackColor: Colors.grey,
      inactiveThumbColor: AppColors.lightGrey,
      title: Row(
        children: [
          const Icon(
            FontAwesomeIcons.bell,
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.08),
            child: Text(
              'Play bell on session start',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      value: state.bellOnSessionStart,
      onChanged: (value) {
        notifier.setBellOnSessionStart(value);
      },
    );
  }
}

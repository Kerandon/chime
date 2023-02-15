import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_colors.dart';
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
        inactiveTrackColor: AppColors.grey,
        inactiveThumbColor: AppColors.lightGrey,
      title: Row(
        children: [
           Padding(
             padding: EdgeInsets.only(right: size.width * 0.05),
             child: SizedBox(
               width: size.width * 0.08,
               child: FaIcon(
                  state.openSession ? FontAwesomeIcons.infinity : Icons.timer_outlined
          ),
             ),
           ),
          const Text('Open session (unlimited time)'),
        ],
      ),
      value: state.openSession,
      onChanged: (value) {
        notifier.setOpenSession();
      },
    );
  }
}

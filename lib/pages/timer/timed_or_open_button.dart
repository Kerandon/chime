import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimedOrOpenButton extends ConsumerWidget {
  const TimedOrOpenButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(stateProvider.notifier);
    final state = ref.watch(stateProvider);
    return Align(
      alignment: const Alignment(0.90, -0.85),
      child: IconButton(
        onPressed: () {
          notifier.setOpenSession();
        },
        icon: Icon(state.openSession
            ? FontAwesomeIcons.infinity
            : Icons.timer_outlined)
      ),
    );
  }
}

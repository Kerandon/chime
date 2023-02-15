import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/constants.dart';
import '../../../../state/app_state.dart';
import 'colon.dart';
import 'number_box.dart';

class SessionTimer extends ConsumerStatefulWidget {
  const SessionTimer({
    super.key,
  });

  @override
  ConsumerState<SessionTimer> createState() => _SessionClockState();
}

class _SessionClockState extends ConsumerState<SessionTimer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);

    final hours = (state.millisecondsRemaining ~/ 3600000);
    final minutes = ((state.millisecondsRemaining ~/ 60000) % 60);
    final seconds = ((state.millisecondsRemaining ~/ 1000) % 60);

    return Center(
      child: SizedBox(
        height: size.height * kClocksHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.totalTimeMinutes >= 60) ...[NumberBox(hours)],
            if (state.totalTimeMinutes >= 60) ...[const Colon()],
            NumberBox(minutes),
            const Colon(),
            NumberBox(seconds),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.milliseconds);
  }
}

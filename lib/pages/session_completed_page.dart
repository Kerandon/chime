import 'package:chime/enums/session_status.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/lotus_icon.dart';
import '../state/state_manager.dart';

class SessionCoverPage extends ConsumerWidget {
  const SessionCoverPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.80, -0.80),
          child: IconButton(icon: const Icon(
            Icons.keyboard_return_outlined,
            color: Colors.white24,
            size: 30,), onPressed: () {

            notifier.setSessionStatus(SessionStatus.notStarted);

          },
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.20),
          child: Container(
            padding: EdgeInsets.all(size.width * 0.20),
            child: Text(
              'Congratulations,\nyour ${state.totalTime} minute mediation session is complete',
              //'Meditation session in process',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w100),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.30),
          child: SizedBox(
              child: SizedBox(width: size.width * 0.20, child: const LotusIcon())),
        ),
      ],
    );
  }
}

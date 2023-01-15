import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/home/lotus_icon.dart';
import '../state/app_state.dart';

class CompletedPage extends ConsumerWidget {
  const CompletedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: const Alignment(0.95, -0.95),
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_return_outlined,
                color: Colors.white24,
              ),
              onPressed: () {
                notifier.setSessionState(SessionState.notStarted);
              },
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
              child: Text(
                'Congratulations\n\nYour ${state.totalTimeMinutes} minute mediation session is complete',
                //'Meditation session in process',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: const Alignment(0, 0.30),
            child: SizedBox(
                child:
                    SizedBox(width: size.width * 0.20, child: const LotusIcon())),
          ),
        ),
      ],
    );
  }
}

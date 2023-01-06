import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartButton extends ConsumerWidget {
  const StartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.05),
      child: Center(
        child: SizedBox(
          height: size.height * 0.10,
          width: size.width,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.teal, shape: const CircleBorder()),
            onPressed: () {
              ref.read(stateProvider.notifier).startSession(start: true);
            },
            child: const Icon(
              Icons.not_started_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

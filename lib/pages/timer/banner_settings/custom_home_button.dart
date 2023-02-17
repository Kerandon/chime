import 'package:chime/animation/pop_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../enums/session_state.dart';
import '../../../state/app_state.dart';

class CustomHomeButton extends ConsumerWidget {
  const CustomHomeButton({
    super.key,
    required this.text,
    required this.iconData,
    required this.onPressed,
    required this.alignment,
    this.increaseSpacing = false,
  });

  final String? text;
  final IconData iconData;
  final VoidCallback onPressed;
  final Alignment alignment;
  final bool increaseSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    return FittedBox(
      child: PopAnimation(
        animate: state.sessionState == SessionState.countdown,
        reset: state.sessionState == SessionState.notStarted,
        reverse: true,
        child: Align(
          alignment: alignment,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).splashColor.withOpacity(0.05),
              side: BorderSide.none,
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: increaseSpacing
                          ? size.width * 0.03
                          : size.width * 0.01),
                  child: Icon(iconData),
                ),
                if (text != null) ...[
                  Text(
                    text!,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

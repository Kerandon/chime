import 'package:chime/enums/focus_state.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartButton extends ConsumerWidget {
  const StartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final notifier = ref.watch(stateProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.05),
      child: Center(
        child: SizedBox(
          height: size.height * 0.10,
          width: size.width,
          child:

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width),
              child: Container(
                child: Material(
                  child: InkWell(
                    onTap: (){print("tapped");},
                    child: Container(
                      width: size.width * 0.20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  color: Colors.transparent,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  image: DecorationImage(image: AssetImage('assets/images/lotus.png', ),)
                ),
              ),
            ),
          ),

          // OutlinedButton(
          //     style: OutlinedButton.styleFrom(
          //         backgroundColor: Colors.teal, shape: const CircleBorder()),
          //     onLongPress: (){
          //       notifier.setSessionStatus(SessionStatus.stopped);
          //     },
          //     onPressed: () {
          //         notifier.setSessionStatus(SessionStatus.inProgress);
          //       notifier.setTimerFocusState(FocusState.unFocus);
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.all(size.width * 0.05),
          //       child: Image.asset(
          //         'assets/images/lotus.png',
          //         color: Colors.white,
          //       ),
          //     ),
          // ),
        ),
      ),
    );
  }
}

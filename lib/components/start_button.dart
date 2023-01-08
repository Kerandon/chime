import 'dart:async';

import 'package:chime/enums/focus_state.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  Timer? _timer;
  bool _longTapInProgress = false;
  Color _buttonColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.watch(stateProvider.notifier);
    final size = MediaQuery.of(context).size;

    if (state.sessionStatus == SessionStatus.paused) {
      _buttonColor = Colors.orangeAccent;
    }
    else if (_longTapInProgress) {
      _buttonColor = Colors.redAccent;
    } else {
      _buttonColor = Colors.teal;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.05),
      child: Center(
        child: SizedBox(
          height: size.height * 0.20,
          width: size.width,
          child: Center(
            child: RawGestureDetector(
              gestures: <Type, GestureRecognizerFactory>{
                TapGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                        () {
                  return TapGestureRecognizer(
                    debugOwner: this,
                  );
                }, (TapGestureRecognizer instance) {
                  instance.onTap = () {
                    print('tapped');

                        if (state.sessionStatus == SessionStatus.stopped) {
                          notifier.setSessionStatus(SessionStatus.inProgress);
                        }
                        if (state.sessionStatus == SessionStatus.inProgress) {
                          notifier.setSessionStatus(SessionStatus.paused);
                        }
                        if (state.sessionStatus == SessionStatus.paused) {
                          notifier.setSessionStatus(SessionStatus.inProgress);
                        }
                  };
                }),
                LongPressGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                        LongPressGestureRecognizer>(
                  () {
                    return LongPressGestureRecognizer(
                      debugOwner: this,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  (LongPressGestureRecognizer instance) {
                    instance.onLongPress = () {
                      print('long press started');
                      _longTapInProgress = true;
                      setState(() {

                      });
                      _timer =
                          Timer.periodic(Duration(milliseconds: 2000), (timer) {
                        print('long press TIMER OFF');
                      });
                    };
                    instance.onLongPressEnd = (details) {
                      print('long pressed ended');
                      _longTapInProgress = false;
                      setState(() {

                      });
                      _timer?.cancel();
                    };
                    instance.onLongPressCancel = () {
                      _longTapInProgress = false;
                      setState(() {

                      });
                      _timer?.cancel();

                    };
                  },
                ),
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.width),
                child: Container(
                  color: _buttonColor,
                  child: Material(
                    color: Colors.transparent,







                    // GestureDetector(
                    //   onTap: () {
                    //     _tapInProgress = true;
                    //     _longTapStarted = false;
                    //     notifier.setTimerFocusState(FocusState.unFocus);
                    //
                    //     if (state.sessionStatus == SessionStatus.stopped) {
                    //       notifier.setSessionStatus(SessionStatus.inProgress);
                    //     }
                    //
                    //     if (state.sessionStatus == SessionStatus.inProgress) {
                    //       notifier.setSessionStatus(SessionStatus.paused);
                    //     }
                    //     if (state.sessionStatus == SessionStatus.paused) {
                    //       notifier.setSessionStatus(SessionStatus.inProgress);
                    //     }
                    //   },
                    //   onTapDown: (details){
                    //     _tapInProgress = true;
                    //     _longTapStarted = false;
                    //     setState(() {
                    //
                    //     });
                    //   },
                    //   onPanDown: (_) {
                    //     notifier.setTimerFocusState(FocusState.unFocus);
                    //       _timer = Timer(
                    //         Duration(milliseconds: 1000),
                    //         () {
                    //           if (_tapInProgress) {
                    //             _longTapStarted = true;
                    //             setState(() {});
                    //           }
                    //         },
                    //       );
                    //
                    //       _timer = Timer(
                    //         Duration(seconds: 3),
                    //         () {
                    //           notifier.setSessionStatus(SessionStatus.stopped);
                    //           _longTapStarted = false;
                    //           setState(() {});
                    //         },
                    //       );
                    //   },
                    //   onTapCancel: () {
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       _tapInProgress = false;
                    //       _longTapStarted = false;
                    //       _timer?.cancel();
                    //       setState(() {});
                    //       print('TAP CANCEL');
                    //     });
                    //   },
                    //   onTapUp: (details) {
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       _tapInProgress = false;
                    //       _longTapStarted = false;
                    //       _timer?.cancel();
                    //       setState(() {});
                    //       print('TAP UP');
                    //     });
                    //   },
                    //   onPanEnd: (details) {
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       _tapInProgress = false;
                    //       _longTapStarted = false;
                    //       _timer?.cancel();
                    //       setState(() {});
                    //       print('PAN END');
                    //     });
                    //   },
                    //   onPanCancel: () {
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       _tapInProgress = false;
                    //       _longTapStarted = false;
                    //       _timer?.cancel();
                    //       setState(() {});
                    //       print('PAN CANCEL');
                    //     });
                    //   },
                    child: InkWell(
                      child: SizedBox(
                        width: size.width * 0.20,
                        height: size.width * 0.20,
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: Image.asset(
                            'assets/images/lotus.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // GestureDetector(
        //   onPanDown: (_){
        //
        //     _timer = Timer(Duration(seconds: 3),(){
        //       print('long tap');
        //     });
        //   },
        //     onPanCancel: () => _timer?.cancel(),
        //   child:

        // OutlinedButton(
        //     style: OutlinedButton.styleFrom(
        //         backgroundColor: Colors.teal, shape: const CircleBorder()),
        //     onLongPress: (){
        //       notifier.setSessionStatus(SessionStatus.stopped);
        //     },
        //     onPressed: () {
        //       //   notifier.setSessionStatus(SessionStatus.inProgress);
        //       // notifier.setTimerFocusState(FocusState.unFocus);
        //     },
        //     child: Padding(
        //       padding: EdgeInsets.all(size.width * 0.05),
        //       child: Image.asset(
        //         'assets/images/lotus.png',
        //         color: Colors.white,
        //       ),
        //     ),
        // ),
        // ),
      ),
    );
  }
}

import 'dart:async';

import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../configs/app_colors.dart';

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

    _buttonColor = Colors.teal;
    if (state.sessionStatus == SessionStatus.paused) {
      _buttonColor = Colors.orangeAccent;
    }
    if (_longTapInProgress) {
      _buttonColor = Colors.redAccent;
    }

    double percentComplete = 0;
    if(state.totalTime != 0) {
      percentComplete = state.secondsRemaining / (state.totalTime * 60);
    }
    percentComplete = (1.0 - percentComplete);
    print('percent complete $percentComplete ${0/5}');

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                () {
          return TapGestureRecognizer(
            debugOwner: this,
          );
        }, (TapGestureRecognizer instance) {
          instance.onTap = () {
            if (state.sessionStatus == SessionStatus.notStarted) {
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
              duration: const Duration(milliseconds: 500),
            );
          },
          (LongPressGestureRecognizer instance) {
            instance.onLongPress = () {
              _longTapInProgress = true;
              setState(() {});
              _timer =
                  Timer.periodic(const Duration(milliseconds: 2000), (timer) {
                notifier.setSessionStatus(SessionStatus.ended);
              });
            };
            instance.onLongPressEnd = (details) {
              setState(
                () {
                  _longTapInProgress = false;
                  _timer?.cancel();
                },
              );
            };
            instance.onLongPressCancel = () {
              setState(
                () {
                  _longTapInProgress = false;
                  _timer?.cancel();
                },
              );
            };
          },
        ),
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0,0.20),
            child: CircularPercentIndicator(
              //progressColor: Theme.of(context).primaryColor,
                linearGradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  Colors.greenAccent
                ]),
                animateFromLastPercent: true,
                animation: true,
                radius: size.width * 0.12,
                lineWidth: 3,
                percent: percentComplete,
                circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(size.width * 0.005),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(size.width),
          //       child: Container(
          //         color: _buttonColor,
          //         child: Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             child: SizedBox(
          //               width: size.width * 0.30,
          //               height: size.width * 0.30,
          //               child: Padding(
          //                 padding: EdgeInsets.all(size.width * 0.05),
          //                 child: Image.asset(
          //                   'assets/images/lotus.png',
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),


        ],
      ),
    );
  }
}

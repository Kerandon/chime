import 'dart:async';
import 'package:chime/audio/audio_manager.dart';
import 'package:chime/components/home/time_adjustment_icons.dart';
import 'package:chime/components/home/time_field.dart';
import 'package:chime/enums/session_status.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../enums/focus_state.dart';
import '../../enums/sounds.dart';
import '../../state/state_manager.dart';
import '../../utils/constants.dart';
import 'countdown_text.dart';

class AppTimer extends ConsumerStatefulWidget {
  const AppTimer({
    super.key,
  });

  @override
  ConsumerState<AppTimer> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimer> {
  CountdownTimer? _timer;
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  int _minRemaining = 0;
  int _secRemaining = 0;
  int _milliSecElapsed = 0;
  bool _sessionStarted = false;
  bool _startCountdownInProgress = false;
  bool _sessionIsCompleted = false;

  void _setTimer(int totalTime) {
    _timer = CountdownTimer(
        Duration(seconds: (totalTime) + 2 - 59), const Duration(seconds: 1))
      ..listen(
        (event) {
          _startCountdownInProgress = false;
          _minRemaining = event.remaining.inMinutes;
          _secRemaining = event.remaining.inSeconds;
          _milliSecElapsed = event.elapsed.inMilliseconds;
          setState(() {});
        },
        onDone: () {
          _sessionIsCompleted = true;
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    int numberOfSounds = 1;
    _setFocus(state);

    numberOfSounds = _setNumberOfSounds(state, numberOfSounds);

    if (state.sessionStatus == SessionStatus.notStarted) {
      _secRemaining = 0;
      _minRemaining = 0;
      _milliSecElapsed = 0;
      _timer?.cancel();
      _sessionStarted = false;
      _sessionIsCompleted = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setSessionHasStarted(false);
      });
    } else if (state.sessionStatus == SessionStatus.inProgress) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setSecondsRemaining(_secRemaining);
        notifier.setMillisecondsElapsed(_milliSecElapsed);
      });

      if (!_sessionStarted) {
        _startCountdownInProgress = true;
        int totalTimeInSeconds = state.totalTime * 60;
        Timer(const Duration(milliseconds: kStartingScreenDuration), () {
          setState(() {});
          _setTimer(totalTimeInSeconds);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifier.setSessionHasStarted(true);
          });
        });

        _sessionStarted = true;
      }
      if (state.pausedTime != 0) {
        _setTimer(state.pausedTime);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setPausedTime(reset: true);
        });
      }
    } else if (state.sessionStatus == SessionStatus.paused) {
      _cancelTimer();
      _sessionIsCompleted = false;
    }

    _calculateBellIntervals(numberOfSounds, state);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_sessionIsCompleted) {
        if (state.sessionStatus != SessionStatus.notStarted) {
          notifier.setSessionStatus(SessionStatus.ended);
        }
      }
    });

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * kHomePageLineWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_startCountdownInProgress) ...[
            const CountdownText(),
          ],
          if (!_startCountdownInProgress) ...[
            state.sessionStatus == SessionStatus.inProgress ||
                    state.sessionStatus == SessionStatus.paused &&
                        !_startCountdownInProgress
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (_secRemaining ~/ 60).toString(),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        TextSpan(
                          text: (_secRemaining % 60).toString(),
                          style:
                              Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  )
                : TimeField(
                    focusNode: _focusNode,
                    textEditingController: _textEditingController,
                  ),
            state.sessionStatus == SessionStatus.notStarted
                ? TimeAdjustmentIcons(focusNode: _focusNode)
                : SizedBox.shrink(),
          ],
        ],
      ),
    );
  }

  int _setNumberOfSounds(AppState state, int numberOfSounds) {
    if (state.totalTime != 0 || state.intervalTime != 0) {
      numberOfSounds = state.totalTime ~/ state.intervalTime;
    }
    return numberOfSounds;
  }

  _cancelTimer() {
    _timer?.cancel();
    setState(() {});
  }

  void _calculateBellIntervals(int numberOfSounds, AppState state) {
    List<int> bellTimes = [];
    for (int i = 0; i < numberOfSounds; i++) {
      int bellTime = state.totalTime - (state.intervalTime * i);
      bellTimes.add(bellTime);
    }

    if (bellTimes
        .any((element) => element == _minRemaining && _secRemaining == 0)) {
      AudioManager().playSound(sound: Sounds.gong.name);
    }
  }

  void _setFocus(AppState state) {
    if (!_focusNode.hasFocus) {
      _textEditingController.text = state.totalTime.toString();
    }

    if (state.focusState == FocusState.unFocus) {
      _focusNode.unfocus();
    }
  }
}

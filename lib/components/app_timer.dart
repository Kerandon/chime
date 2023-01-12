import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chime/audio/audio_manager.dart';
import 'package:chime/enums/session_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

import '../enums/focus_state.dart';
import '../enums/sounds.dart';
import '../state/state_manager.dart';
import '../utils/constants.dart';

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
  bool _sessionStarted = false;
  bool _startCountdownInProgress = false;
  bool _sessionIsCompleted = false;

  void _setTimer(int totalTime) {
    _timer = CountdownTimer(
        Duration(seconds: totalTime + 2), const Duration(milliseconds: 1000))
      ..listen(
        (event) {
          _startCountdownInProgress = false;
          _minRemaining = event.remaining.inMinutes;
          _secRemaining = event.remaining.inSeconds;
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
      _timer?.cancel();
      _sessionStarted = false;
      _sessionIsCompleted = false;

    } else if (state.sessionStatus == SessionStatus.inProgress) {
      if (!_sessionStarted) {
        _startCountdownInProgress = true;
        int totalTimeInSeconds = state.totalTime * 60;
        Timer(const Duration(milliseconds: kStartingScreenDuration), () {
          setState(() {});
          _setTimer(totalTimeInSeconds);
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.setSecondsRemaining(_secRemaining);
      if (_sessionIsCompleted) {
        if (state.sessionStatus != SessionStatus.notStarted) {
          print('run here');
          notifier.setSessionStatus(SessionStatus.ended);
        }
      }
    });

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_startCountdownInProgress) ...[
            AnimatedTextKit(
                pause: const Duration(milliseconds: 600),
                isRepeatingAnimation: false,
                animatedTexts: [
                  FadeAnimatedText('3',
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.white),
                      duration: const Duration(milliseconds: 1500),
                      fadeOutBegin: 0.90,
                      fadeInEnd: 0.7),
                  FadeAnimatedText('2',
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.white),
                      duration: const Duration(milliseconds: 1500),
                      fadeOutBegin: 0.90,
                      fadeInEnd: 0.7),
                  FadeAnimatedText('1',
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.white),
                      duration: const Duration(milliseconds: 1500),
                      fadeOutBegin: 0.90,
                      fadeInEnd: 0.7),
                ]),
          ],
          if (!_startCountdownInProgress) ...[
            state.sessionStatus == SessionStatus.inProgress ||
                    state.sessionStatus == SessionStatus.paused &&
                        !_startCountdownInProgress
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (_secRemaining ~/ 60).toString(),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        TextSpan(
                            text: (_secRemaining % 60).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  )
                : TextFormField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    onChanged: (value) {
                      notifier.setTimerFocusState(FocusState.inFocus);
                      if (value.trim() == "") {
                        notifier.setTotalTime(0);
                      } else {
                        notifier.setTotalTime(int.parse(value));
                      }
                    },
                    maxLength: 4,
                    style: Theme.of(context).textTheme.displayLarge,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      counterText: "",
                    ),
                  ),
            state.sessionStatus == SessionStatus.notStarted
                ? SizedBox(
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _focusNode.unfocus();
                            notifier.incrementTotalTime();
                          },
                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.10,
                        ),
                        IconButton(
                          onPressed: () {
                            _focusNode.unfocus();
                            notifier.decrementTotalTime();
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: size.height * 0.05,
                  ),
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
      AudioManager().playAudio(sound: Sounds.gong.name);
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

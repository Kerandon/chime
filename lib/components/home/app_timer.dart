import 'dart:async';
import 'package:chime/audio/audio_manager.dart';
import 'package:chime/components/home/time_adjustment_icons.dart';
import 'package:chime/components/home/time_field.dart';
import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../enums/focus_state.dart';
import '../../enums/sounds.dart';
import '../../state/app_state.dart';
import '../../utils/constants.dart';
import 'count_down_clock.dart';
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
  bool _mainTimerIsSet = false;
  bool _sessionIsCompleted = false;

  void _setTimer(int totalTime) {
    _timer = CountdownTimer(
        Duration(seconds: (totalTime) + 1), const Duration(seconds: 1))
      ..listen(
        (event) {
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

    if (state.sessionState == SessionState.notStarted) {
      _secRemaining = 0;
      _minRemaining = 0;
      _timer?.cancel();
      _mainTimerIsSet = false;
      _sessionIsCompleted = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setSessionHasStarted(false);
      });
    } else if (state.sessionState == SessionState.countdown) {
      if (!_mainTimerIsSet) {
        int totalTimeInSeconds = state.totalTimeMinutes * 60;
        Timer(const Duration(milliseconds: kStartingScreenDuration), () {
          _setTimer(totalTimeInSeconds);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifier.setSessionState(SessionState.inProgress);
            notifier.setSessionHasStarted(true);
          });
        });
        setState(() {
          _mainTimerIsSet = true;
        });
      }
    } else if (state.sessionState == SessionState.inProgress) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setSecondsRemaining(_secRemaining);
      });
      if (state.pausedTime != 0) {
        _setTimer(state.pausedTime);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setPausedTime(reset: true);
        });
      }
    } else if (state.sessionState == SessionState.paused) {
      _cancelTimer();
      _sessionIsCompleted = false;
    }

    _calculateBellIntervals(numberOfSounds, state);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_sessionIsCompleted) {
        if (state.sessionState != SessionState.notStarted) {
          notifier.setSessionState(SessionState.ended);
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
          if (state.sessionState == SessionState.notStarted ||
              state.sessionState == SessionState.ended) ...[
            TimeField(
              focusNode: _focusNode,
              textEditingController: _textEditingController,
            ),
            const TimeAdjustmentIcons()
          ],
          if (state.sessionState == SessionState.countdown) ...[
            const CountdownText(),
          ],
          if (state.sessionState == SessionState.inProgress ||
              state.sessionState == SessionState.paused) ...[
            const SessionClock()
          ],
        ],
      ),
    );
  }

  int _setNumberOfSounds(AppState state, int numberOfSounds) {
    if (state.totalTimeMinutes != 0 || state.intervalTimeMinutes != 0) {
      numberOfSounds = state.totalTimeMinutes ~/ state.intervalTimeMinutes;
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
      int bellTime = state.totalTimeMinutes - (state.intervalTimeMinutes * i);
      bellTimes.add(bellTime);
    }

    if (bellTimes
        .any((element) => element == _minRemaining && _secRemaining == 0)) {
      AudioManager().playSound(sound: Sounds.gong.name);
    }
  }

  void _setFocus(AppState state) {
    if (!_focusNode.hasFocus) {
      _textEditingController.text = state.totalTimeMinutes.toString();
    }

    if (state.focusState == FocusState.unFocus) {
      _focusNode.unfocus();
    }
  }
}

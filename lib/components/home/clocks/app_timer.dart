import 'dart:async';
import 'package:chime/components/home/clocks/time_adjustment_icons.dart';
import 'package:chime/components/home/clocks/time_field.dart';
import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../audio/audio_manager.dart';
import '../../../enums/focus_state.dart';
import '../../../state/app_state.dart';
import '../../../utils/constants.dart';
import 'session_timer.dart';
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
  int _secRemaining = 0;
  bool _mainTimerIsSet = false;
  bool _sessionIsCompleted = false;
  bool _firstBellHasRung = false;
  bool _lastBellHAsRung = false;

  void _setTimer(int totalTime) {
    _timer = CountdownTimer(
        Duration(seconds: (totalTime) + 1 - 59), const Duration(seconds: 1))
      ..listen(
        (event) {
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
    _setFocus(state);

    if (state.sessionState == SessionState.notStarted) {
      _secRemaining = 0;
      _timer?.cancel();
      _mainTimerIsSet = false;
      _sessionIsCompleted = false;
      _firstBellHasRung = false;
      _lastBellHAsRung = false;
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
      if (!_firstBellHasRung) {
        AudioManager().playSound(state.soundSelected.name);
        _firstBellHasRung = true;
      }
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
    } else if (state.sessionState == SessionState.ended) {
      print('state ended!!!');
      if(!_lastBellHAsRung) {
        AudioManager().playSound('${state.soundSelected.name}_end');
        _lastBellHAsRung = true;
      }
    }

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
            const SessionTimer()
          ],
        ],
      ),
    );
  }

  _cancelTimer() {
    _timer?.cancel();
    setState(() {});
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

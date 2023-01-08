import 'package:chime/audio/audio_manager.dart';
import 'package:chime/enums/session_status.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

import '../enums/focus_state.dart';
import '../enums/sounds.dart';
import '../state/state_manager.dart';

class AppTimer extends ConsumerStatefulWidget {
  const AppTimer({
    super.key,
  });

  @override
  ConsumerState<AppTimer> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimer> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  int _minRemaining = 0;
  int _secRemaining = 0;
  bool _sessionStarted = false;

  void _setTimer(int totalTime) {
    CountdownTimer(Duration(minutes: totalTime), const Duration(seconds: 1))
        .listen(
      (event) {
        _minRemaining = event.remaining.inMinutes;
        _secRemaining = event.remaining.inSeconds;
        _secRemaining = event.remaining.inSeconds % 60;
        setState(() {});
      },
      onDone: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    int numberOfSounds = 1;
    _setFocus(state);

    if (state.totalTime != 0 || state.intervalTime != 0) {
      numberOfSounds = state.totalTime ~/ state.intervalTime;
    }
    if (state.sessionStatus == SessionStatus.inProgress) {
      if (!_sessionStarted) {
        _setTimer(state.totalTime);
        _sessionStarted = true;
      }
    }
    if(state.sessionStatus == SessionStatus.stopped){
      print('STOP!');
    }

    List<int> bellTimes = [];
    for (int i = 0; i < numberOfSounds; i++) {
      int bellTime = state.totalTime - (state.intervalTime * i);
      bellTimes.add(bellTime);
    }

    if (bellTimes
        .any((element) => element == _minRemaining && _secRemaining == 0)) {
      AudioManager().playAudio(sound: Sounds.gong.name);
    }

    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: const Alignment(0.50, 0.0),
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.015),
            child: Text(
              numberOfSounds.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white54),
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.70,
          height: size.height * 0.20,
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: _minRemaining.toString(),
                    style: Theme.of(context).textTheme.displayLarge),
                TextSpan(
                    text: _secRemaining.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.normal)),
              ])),

          // TextFormField(
          //   focusNode: _focusNode,
          //   controller: _textEditingController,
          //   onChanged: (value) {
          //     notifier.setTimerFocusState(FocusState.inFocus);
          //     if (value.trim() == "") {
          //       notifier.setTotalTime(0);
          //     } else {
          //       notifier.setTotalTime(int.parse(value));
          //     }
          //   },
          //   maxLength: 4,
          //   style: Theme.of(context).textTheme.displayLarge,
          //   keyboardType: TextInputType.number,
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //   textAlign: TextAlign.center,
          //   decoration: const InputDecoration(
          //     contentPadding: EdgeInsets.zero,
          //     counterText: "",
          //   ),
          // ),
        ),
        Row(
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
        )
      ],
    );
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

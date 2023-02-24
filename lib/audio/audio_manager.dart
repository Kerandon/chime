import 'dart:math';

import 'package:chime/configs/constants.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/audio_state.dart';
import 'package:chime/utils/methods/random.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../enums/interval_bell.dart';

class AudioManager extends ConsumerStatefulWidget {
  const AudioManager({Key? key}) : super(key: key);

  @override
  ConsumerState<AudioManager> createState() => _AudioManagerState();
}

class _AudioManagerState extends ConsumerState<AudioManager> {
  final AudioPlayer _playerBell = AudioPlayer();
  Bell _selectedBell = Bell.chime;
  bool _playerBellIsSetOnInit = false;
  bool _setInitialInterval = false;
  int _nextBellTime = 0;
  int _currentBellIndex = 0;
  int _maxBells = 0;

  @override
  initState() {
    super.initState();
  }

  Future<void> _setBell(Bell bell) async {
    await _playerBell.setAsset('assets/audio/bells/${bell.name}.mp3',
        preload: true);
    _selectedBell = bell;
  }

  Future<void> _playAudio() async {
    await _playerBell.seek(Duration.zero);
    await _playerBell.play();
  }

  @override
  void dispose() {
    _playerBell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(stateProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    int elapsedSeconds = appState.millisecondsElapsed ~/ 1000;

    if (appState.sessionState == SessionState.notStarted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        audioNotifier.setBellOnBeginHasPlayed(false);
        audioNotifier.setBellOnBeginHasPlayed(false);
      });
      _maxBells = 0;
      _currentBellIndex = 0;
    }

    if (appState.sessionState == SessionState.inProgress) {
      if (!audioState.bellOnBeginHasPlayed) {
        _playAudio();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          audioNotifier.setBellOnBeginHasPlayed(true);
        });
      }

      if (audioState.intervalBellType == BellIntervalTypeEnum.fixed) {
        _calculateFixedIntervalBells(
            appState: appState,
            bellInterval: audioState.bellInterval,
            elapsedSeconds: elapsedSeconds);
      }
      if (audioState.intervalBellType == BellIntervalTypeEnum.random) {
        _calculateRandomBells(
            elapsedSeconds: elapsedSeconds, maxRandomRange: audioState.maxRandomBell,
        totalTime: appState.totalTimeMinutes * 60
        );
      }
    }
    if (appState.sessionState == SessionState.ended) {
      if (!audioState.bellOnEndHasPlayed) {
        _playAudio();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          audioNotifier.setAudioOnEndHasPlayed(true);
        });
      }
    }
    if (!_playerBellIsSetOnInit) {
      _selectedBell = audioState.bellSelected;
      _setBell(_selectedBell);
      _playerBellIsSetOnInit = true;
    }

    if (audioState.bellSelected != _selectedBell) {
      _setBell(audioState.bellSelected);
    }

    return const SizedBox.shrink();
  }

  void _calculateFixedIntervalBells(
      {required AppState appState,
      required double bellInterval,
      required int elapsedSeconds}) {
    int intervalTimeSeconds = (bellInterval * 60).toInt();

    if (!_setInitialInterval) {
      _nextBellTime = intervalTimeSeconds;

      if (!appState.openSession) {
        _maxBells =
            ((appState.totalTimeMinutes * 60) ~/ intervalTimeSeconds) - 1;
      } else {
        _maxBells = ((1440 * 60) ~/ intervalTimeSeconds) - 1;
      }
      _setInitialInterval = true;
    }

    if (elapsedSeconds >= _nextBellTime && _currentBellIndex < _maxBells) {
      _nextBellTime += intervalTimeSeconds;
      _maxBells++;
      _playAudio();
    }
  }

  void _calculateRandomBells({required int elapsedSeconds, required double maxRandomRange, required int totalTime}) {

    int min = 58;
    if(totalTime == 60) {
      min = 15;
    }
    int max = (maxRandomRange * 60).toInt();

    if (!_setInitialInterval) {
      _nextBellTime = RandomClass.next(min, max);
      _setInitialInterval = true;
    }

    if (elapsedSeconds > _nextBellTime) {
      _nextBellTime = RandomClass.next(min, max);
      _nextBellTime += elapsedSeconds;
      _playAudio();
    }
  }
}

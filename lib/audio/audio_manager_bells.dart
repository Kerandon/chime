import 'package:chime/enums/bell.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/audio_state.dart';
import 'package:chime/utils/methods/random.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../enums/audio_state.dart';
import '../enums/interval_bell.dart';

class AudioManagerBells extends ConsumerStatefulWidget {
  const AudioManagerBells({Key? key}) : super(key: key);

  @override
  ConsumerState<AudioManagerBells> createState() => _AudioManagerState();
}

class _AudioManagerState extends ConsumerState<AudioManagerBells> {
  late final AudioPlayer _player;
  AudioStateEnum _state = AudioStateEnum.stopped;
  Bell _selectedBell = Bell.chime;
  bool _playerBellIsSetOnInit = false;
  bool _setInitialInterval = false;
  int _nextBellTime = 0;
  int _currentBellIndex = 0;
  int _maxBells = 0;

  @override
  initState(){

    _player = AudioPlayer()..playerStateStream.listen((state) {
      if(state.playing){
        _state = AudioStateEnum.playing;
      }
      switch(state.processingState){
        case ProcessingState.idle:
          _state = AudioStateEnum.idle;
          break;
        case ProcessingState.loading:
          _state = AudioStateEnum.loading;
          break;
        case ProcessingState.buffering:
          _state = AudioStateEnum.loading;
          break;
        case ProcessingState.ready:
          _state = AudioStateEnum.ready;
          break;
        case ProcessingState.completed:
          _state = AudioStateEnum.idle;
          break;
      }
    });
    super.initState();
  }

  Future<void> _setBell(Bell bell) async {
    if (_state == AudioStateEnum.idle) {
      await _player.setAsset('assets/audio/bells/${bell.name}.mp3',
          preload: true);
      _selectedBell = bell;
    }
  }

  Future<void> _playAudio() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    int elapsedSeconds = appState.millisecondsElapsed ~/ 1000;

    if (appState.sessionState == SessionState.notStarted) {
      _resetOnNotStarted(audioNotifier);
    }

    if (appState.sessionState == SessionState.inProgress) {
      _playBellOnBegin(audioState, audioNotifier);

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

  void _resetOnNotStarted(AudioNotifier audioNotifier) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      audioNotifier.setBellOnBeginHasPlayed(false);
    });
    _playerBellIsSetOnInit = false;
    _setInitialInterval = false;
    _nextBellTime = 0;
    _currentBellIndex = 0;
    _maxBells = 0;
  }

  void _playBellOnBegin(AudioState audioState, AudioNotifier audioNotifier) {
    if (!audioState.bellOnBeginHasPlayed) {
      _playAudio();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        audioNotifier.setBellOnBeginHasPlayed(true);
      });
    }
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
    //
    print('next bell time is $_nextBellTime'
        'current bell index is $_currentBellIndex'
        'and max bells is $_maxBells');

    if (elapsedSeconds >= _nextBellTime && _currentBellIndex < _maxBells) {
      _nextBellTime += intervalTimeSeconds;
      _maxBells++;
      _currentBellIndex++;
      _playAudio();
    }
  }

  void _calculateRandomBells({required int elapsedSeconds, required double maxRandomRange, required int totalTime}) {


    int min = 59;
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

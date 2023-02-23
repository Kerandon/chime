import 'package:chime/configs/constants.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

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
  int _nextIntervalSeconds = 0;
  int _maxBells = 0;
  int _currentBell = 0;

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

    if (appState.sessionState == SessionState.notStarted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        audioNotifier.setBellOnBeginHasPlayed(false);
        audioNotifier.setBellOnBeginHasPlayed(false);
      });
      _maxBells = 0;
      _currentBell = 0;
    }

    if (appState.sessionState == SessionState.inProgress) {
      if (!audioState.bellOnBeginHasPlayed) {
        _playAudio();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          audioNotifier.setBellOnBeginHasPlayed(true);
        });
      }

      int intervalTimeSeconds = (audioState.bellInterval * 60).toInt();

      if (!_setInitialInterval) {
        _nextIntervalSeconds = intervalTimeSeconds;
        print('interval ${intervalTimeSeconds} and ${appState.totalTimeMinutes * 60}...');


        if(!appState.openSession){
          _maxBells = ((appState.totalTimeMinutes * 60) ~/ intervalTimeSeconds) - 1;
        }else{
          _maxBells = ((1440 * 60) ~/ intervalTimeSeconds) - 1;
        }





        print('max bells ************* $_maxBells');
        _setInitialInterval = true;
      }

      print('interval time seconds $intervalTimeSeconds '
          'and _nextIntervalSeconds is $_nextIntervalSeconds');

      print(appState.millisecondsElapsed);

      if ((appState.millisecondsElapsed ~/ 1000) >= _nextIntervalSeconds && _currentBell < _maxBells) {
        _nextIntervalSeconds += intervalTimeSeconds;
        _maxBells++;
        _playAudio();
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
}

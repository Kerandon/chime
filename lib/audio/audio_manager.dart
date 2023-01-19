import 'package:audioplayers/audioplayers.dart';
import 'package:chime/configs/constants.dart';
import 'package:chime/enums/audio_type.dart';
import 'package:quiver/async.dart';

import '../enums/ambience.dart';
import '../enums/bell.dart';

class AudioManager {
  AudioManager._private();

  static final _instance = AudioManager._private();

  factory AudioManager() => _instance;

  AudioPlayer playerBell = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  AudioPlayer playerAmbience = AudioPlayer()..setReleaseMode(ReleaseMode.loop);

  Future<void> playBell({required Bell bell, bool finalBell = false}) async {
    if (!finalBell) {
      await playerBell.play(AssetSource('audio/bells/${bell.name}.mp3'));
    } else {
      await playerBell.play(AssetSource('audio/bells/${bell.name}_end.mp3'));
    }
  }

  Future<void> playAmbience(
      {required Ambience ambience,
      int fadeInMilliseconds = kAudioFadeDuration}) async {
    if (ambience == Ambience.none) {
      return;
    } else {
      playerAmbience.play(AssetSource('audio/ambience/${ambience.name}.mp3'));
      CountdownTimer(Duration(milliseconds: fadeInMilliseconds),
              const Duration(milliseconds: 50))
          .listen(
        (event) {
          setVolume(
              volume: event.elapsed.inMilliseconds / fadeInMilliseconds,
              audioType: AudioType.ambience);
        },
      );
    }
  }

  Future<void> setVolume(
      {required AudioType audioType, required double volume}) async {
    if (audioType == AudioType.bells) {
      await playerBell.setVolume(volume);
    } else {
      await playerAmbience.setVolume(volume);
    }
  }

  Future<void> stop(
      {required AudioType audioType, int? fadeOutMilliseconds}) async {
    if (fadeOutMilliseconds == null) {
      if (audioType == AudioType.bells) {
        await _stopAndReleaseBellAudio();
      } else {
        await _stopAndReleaseAmbienceAudio();
      }
    } else {
      CountdownTimer(Duration(milliseconds: fadeOutMilliseconds),
              const Duration(milliseconds: 50))
          .listen(
        (event) {
          setVolume(
              audioType: audioType,
              volume: event.remaining.inMilliseconds / fadeOutMilliseconds);
        },
        onDone: () async {
          if (audioType == AudioType.bells) {
            await _stopAndReleaseBellAudio();
          } else {
            await _stopAndReleaseAmbienceAudio();
          }
        },
      );
    }
  }

  Future<void> pauseAmbience() async {
    await playerAmbience.pause();
  }

  Future<void> resumeAmbience() async {
    await playerAmbience.resume();
  }

  Future<void> _stopAndReleaseBellAudio() async {
    await playerBell.stop().then((value) async {
      await playerBell.release();
    });
  }

  Future<void> _stopAndReleaseAmbienceAudio() async {
    await playerAmbience.stop().then((value) async {
      playerAmbience.release();
    });
  }
}

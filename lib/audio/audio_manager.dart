import 'package:audioplayers/audioplayers.dart';
import 'package:chime/enums/ambience.dart';

class AudioManager {
  AudioManager._private();

  static final _instance = AudioManager._private();

  factory AudioManager() => _instance;

  AudioPlayer audioPlayerSound = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);
  AudioPlayer audioPlayerAmbience = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);

  Future<void> playSound(sound) async {
    print('play audio ${sound}');
    await audioPlayerSound.play(AssetSource('audio/sounds/$sound.mp3'));
  }

  Future<void> playAmbience(Ambience ambience) async {
    if (ambience == Ambience.none) {
      await audioPlayerAmbience.stop();
    } else {
      await audioPlayerAmbience
          .play(AssetSource('audio/ambience/${ambience.name}.mp3'), volume: 1);
    }
  }

  Future<void> setAmbienceVolume(double volume) async {
    await audioPlayerAmbience.setVolume(volume);
  }

  Future<void> stopSoundAudio() async {
    await audioPlayerSound.stop().then((value) async {
      await audioPlayerAmbience.release();
    });
  }

  Future<void> stopAmbienceAudio() async {
    await audioPlayerAmbience.stop().then((value) async {
      await audioPlayerAmbience.release();
    });
  }

  Future<void> pauseAmbience() async {
    await audioPlayerAmbience.pause();
  }

  Future<void> resumeAmbience() async {
    await audioPlayerAmbience.resume();
  }

}

import 'package:audioplayers/audioplayers.dart';
import 'package:chime/enums/ambience.dart';

class AudioManager {
  AudioManager._private();

  static final _instance = AudioManager._private();

  factory AudioManager() => _instance;

  AudioPlayer audioPlayerBell = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  AudioPlayer audioPlayerAmbience = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);

  Future<void> playBell(sound) async {
    await audioPlayerBell.play(AssetSource('audio/sounds/$sound.mp3'));
  }

  Future<void> stopBellAudio() async {
    await audioPlayerBell.stop().then((value) async {
      await audioPlayerBell.release();
    });
  }

  Future<void> setBellVolume(double volume) async {
    await audioPlayerBell.setVolume(volume);
  }

  Future<void> setAmbienceVolume(double volume) async {
    await audioPlayerAmbience.setVolume(volume);
  }

  Future<void> playAmbience(Ambience ambience) async {
    if (ambience == Ambience.none) {
      await audioPlayerAmbience.stop();
    } else {
      await audioPlayerAmbience
          .play(AssetSource('audio/ambience/${ambience.name}.mp3'), volume: 1);
    }
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

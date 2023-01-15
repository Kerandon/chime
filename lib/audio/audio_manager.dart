import 'package:audioplayers/audioplayers.dart';
import 'package:chime/enums/ambience.dart';

class AudioManager {
  AudioManager._private();

  static final _instance = AudioManager._private();

  factory AudioManager() => _instance;

  AudioPlayer audioPlayerSound = AudioPlayer();
  AudioPlayer audioPlayerAmbience = AudioPlayer();

  Future<void> playSound({required String sound}) async {
    await audioPlayerSound.play(AssetSource('audio/sounds/$sound.mp3'));
  }

  Future<void> playAmbience({required Ambience ambience}) async {
    await audioPlayerAmbience.play(AssetSource('audio/ambience/${ambience.name}.mp3'));
  }

}

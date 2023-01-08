import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._private();

  static final _instance = AudioManager._private();

  factory AudioManager() => _instance;

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playAudio({required String sound}) async {
    await audioPlayer.play(AssetSource('audio/$sound.mp3'));
  }
}

import 'package:just_audio/just_audio.dart';
import '../enums/ambience.dart';

class AudioManagerAmbience {
  AudioManagerAmbience._private();

  static final _internal = AudioManagerAmbience._private();

  factory AudioManagerAmbience() => _internal;

  final AudioPlayer _player = AudioPlayer();

  int position = 0;


  Future<void> playAmbience({required Ambience ambience, required volume}) async {
    _player
        .setAsset('assets/audio/ambience/${ambience.name}.mp3')
        .then((value) async {
      await _player.seek(Duration.zero);
      await _player.setVolume(volume);
      await _player.play();
    });


  }

  Future<void> pauseAmbience() async {
    await _player.pause();
  }

  Future<void> resumeAmbience() async {

    if(!_player.playing) {
      await _player.play();
    }
  }

  Future<void> stopAmbience() async {
    await _player.stop();
  }

  // Future<void> fadeOutStopAmbience({required double startVolume, duration = 3000}) async {
  //   CountdownTimer(
  //           Duration(milliseconds: duration), const Duration(milliseconds: 50))
  //       .listen((event) {
  //     final percent = event.remaining.inMilliseconds / duration;
  //     setVolume(percent * startVolume);
  //   }).onDone(() async {
  //    await stopAmbience();
  //   });
  // }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

}

import 'package:just_audio/just_audio.dart';
import '../enums/ambience.dart';

class AudioManagerNew {
  AudioManagerNew._private();

  static final _internal = AudioManagerNew._private();

  factory AudioManagerNew() => _internal;

  AudioPlayer ambiencePlayer = AudioPlayer();

  int position = 0;


  Future<void> playAmbience({required Ambience ambience, required volume}) async {
    ambiencePlayer
        .setAsset('assets/audio/ambience/${ambience.name}.mp3')
        .then((value) async {
      await ambiencePlayer.seek(Duration.zero);
      await ambiencePlayer.setVolume(volume);
      await ambiencePlayer.play();
    });

    print(ambiencePlayer.positionStream.listen((event) {
      print(event.inMilliseconds);
      position = event.inMilliseconds;
    }));

    print(ambiencePlayer.position);

  }

  Future<void> pauseAmbience() async {
    await ambiencePlayer.pause();
  }

  Future<void> resumeAmbience() async {

    if(!ambiencePlayer.playing) {
      await ambiencePlayer.play();
    }
  }

  Future<void> stopAmbience() async {
    await ambiencePlayer.stop();
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
    await ambiencePlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await ambiencePlayer.dispose();
  }

}

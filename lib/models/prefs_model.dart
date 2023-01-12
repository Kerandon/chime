import '../enums/sounds.dart';

class PrefsModel {
  final int time;
  final int interval;
  final Sounds sound;

  PrefsModel({required this.time, required this.interval, required this.sound});

}

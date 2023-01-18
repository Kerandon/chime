import '../enums/ambience.dart';
import '../enums/bell.dart';

class PrefsModel {
  final int totalTime;
  final int bellInterval;
  final Bell bellSelected;
  final double bellVolume;
  final Ambience ambienceSelected;
  final double ambienceVolume;

  PrefsModel({
    required this.totalTime,
    required this.bellInterval,
    required this.bellSelected,
    required this.bellVolume,
    required this.ambienceSelected,
    required this.ambienceVolume,
  });
}

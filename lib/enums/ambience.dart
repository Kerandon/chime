enum Ambience {
  none,
  forest,
  rain,
  fireplace,
  meditationMusic1,
  meditationMusic2,
  meditationMusic3,
  meditationMusic4
}

extension AmbienceText on Ambience {
  String toText() {
    switch (this) {
      case Ambience.none:
        return 'None';
      case Ambience.forest:
        return 'Forest';
      case Ambience.rain:
        return 'Rain';
      case Ambience.fireplace:
        return 'Fireplace';
      case Ambience.meditationMusic1:
        return 'Meditation Music 1';
      case Ambience.meditationMusic2:
        return 'Meditation Music 2';
      case Ambience.meditationMusic3:
        return 'Meditation Music 3';
      case Ambience.meditationMusic4:
        return 'Meditation Music 4';
    }
  }
}

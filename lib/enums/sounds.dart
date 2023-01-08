enum Sounds { chime, gong }

extension Sound on Sounds {
  String toText() {
    switch (this) {
      case Sounds.chime:
        return 'Chime';
      case Sounds.gong:
        return 'Gong';
    }
  }
}

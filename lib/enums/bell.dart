enum Bell {
  chime,
  gong,
}

extension ToText on Bell {
  String toText() {
    switch (this) {
      case Bell.chime:
        return 'Chime';
      case Bell.gong:
        return 'Gong';
    }
  }
}

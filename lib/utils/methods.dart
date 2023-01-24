String formatMinToHourMin(int mins) {
  int m = mins % 60;
  int h = mins ~/ 60;

  if (h == 0) {
    return '${m}m';
  } else {
    if (m > 1) {
      return '${h}h\n${m}min';
    } else if (m == 0) {
      return '${h}h';
    }
  }
  return "";
}

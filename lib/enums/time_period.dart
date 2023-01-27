enum TimePeriod { week, fortnight, year, allTime }

extension AsText on TimePeriod {
  String toText() {
    switch (this) {
      case TimePeriod.week:
        return 'Week';
      case TimePeriod.fortnight:
        return '14 Days';
      case TimePeriod.year:
        return 'Year';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }
}

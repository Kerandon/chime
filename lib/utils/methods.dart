import '../models/stats_model.dart';

String formatMinToHourMin(int mins) {
  int m = mins % 60;
  int h = mins ~/ 60;

  if (h == 0) {
    return '${m}m';
  } else {
    if (m > 1) {
      return '${h}h\n${m}m';
    } else if (m == 0) {
      return '${h}h';
    }
  }
  return "";
}

extension FormatMin on int {
  String formatToHourMin() {
    int m = this % 60;
    int h = this ~/ 60;

    if (h == 0) {
      return '${m}m';
    } else {
      if (m > 1) {
        return '${h}h ${m}m';
      } else if (m == 0) {
        return '${h}h';
      }
    }
    return "";
  }
}

extension DateSuffix on int {
  String addDateSuffix() {
    if (this >= 11 && this <= 13) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

String getCurrentStreak(List<StatsModel> stats) {
  int currentStreak = 0;

  DateTime now = DateTime.now();

  for (int i = 0; i < stats.length; i++) {
    final s = stats[i].dateTime;
    var t = DateTime(s.year, s.month, s.day);
    var d = DateTime(now.year, now.month, now.day - i);

    if (t.compareTo(d) == 0) {
      currentStreak++;
    } else {
      break;
    }
  }

  String currentStreakString = "0";
  if (currentStreak == 1) {
    currentStreakString = '1 day';
  }
  if (currentStreak > 1) {
    currentStreakString = '$currentStreak days';
  }
  return currentStreakString;
}

String getBestStreak(List<StatsModel> stats) {
  List<DateTime> dates = [];
  for (var s in stats) {
    dates.add(s.dateTime);
  }
  dates = dates.reversed.toList();

  int longestStreakLength = 0, currentStreakLength = 0;

  for (int i = 0; i < dates.length; i++) {
    if (i == 0 ||
        dates[i].compareTo(DateTime(
                dates[i].year, dates[i].month, dates[i - 1].day + 1)) ==
            0) {
      currentStreakLength++;
    } else {
      currentStreakLength = 1;
    }

    if (currentStreakLength > longestStreakLength) {
      longestStreakLength = currentStreakLength;
    }
  }

  String streakString = "";

  if (longestStreakLength == 1) {
    streakString = '$longestStreakLength day';
  } else {
    streakString = '$longestStreakLength days';
  }

  return streakString;
}

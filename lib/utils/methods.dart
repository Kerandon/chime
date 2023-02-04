
import '../enums/time_period.dart';
import '../models/stats_model.dart';
import '../state/app_state.dart';
import '../state/chart_state.dart';

extension Format on int {
  String formatToHour() {
    var result = this ~/ 60;
    if(result == 0){
      return "";
    }else {
      return '${result}h';
    }
  }
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


String calculateTotalMeditationTime(
    List<StatsModel> data, ChartState state) {
  int totalTime = 0;

  for (var d in data) {
    totalTime += d.totalMeditationTime;
  }
  String totalTimeFormatted = totalTime.formatToHourMin();
  String timeString;

  switch (state.barChartTimePeriod) {
    case TimePeriod.week:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.fortnight:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.year:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.allTime:
      timeString = totalTimeFormatted;
      break;
  }
  return timeString;
}

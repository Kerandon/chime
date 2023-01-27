import 'package:equatable/equatable.dart';

import '../enums/time_period.dart';
import '../state/database_manager.dart';

class StatsModel
   extends Equatable {
  final DateTime dateTime;
  final int totalMeditationTime;
  final TimePeriod timePeriod;

  const StatsModel(
      {required this.dateTime,
      required this.totalMeditationTime,
      this.timePeriod = TimePeriod.week});

  factory StatsModel.fromMap(Map<String, dynamic> map, {bool formatDate = true}) {

    String dateTime = map[DatabaseManager.statsDateTime];

    if(formatDate) {
      dateTime = map[DatabaseManager.statsDateTime]
          .toString()
          .split('-')
          .reversed
          .join()
          .padRight(7, '01');
    }


    return StatsModel(
      dateTime: DateTime.parse(dateTime),
      totalMeditationTime: map[DatabaseManager.statsTotalMeditationTime],
    );
  }

  @override
  List<Object?> get props {
    switch (timePeriod) {
      case TimePeriod.week:
        return [dateTime.day];
      case TimePeriod.fortnight:
        return [dateTime.day];
      case TimePeriod.year:
        return [dateTime.month];
      case TimePeriod.allTime:
        return [dateTime.year];
    }
  }
}

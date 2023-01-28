import 'package:equatable/equatable.dart';

import '../enums/time_period.dart';
import '../state/database_manager.dart';

class StatsModel extends Equatable {
  final DateTime dateTime;
  final int totalMeditationTime;
  TimePeriod timePeriod;

  StatsModel({
    required this.dateTime,
    required this.totalMeditationTime,
    this.timePeriod = TimePeriod.week,
  });

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    String dateTime = map[DatabaseManager.statsDateTime];

    return StatsModel(
      dateTime: DateTime.parse(dateTime),
      totalMeditationTime: map[DatabaseManager.statsTotalMeditationTime],
    );
  }

  @override
  List<Object?> get props {
    switch (timePeriod) {
      case TimePeriod.week:
        return [dateTime.weekday];
      case TimePeriod.fortnight:
        return [dateTime.weekday];
      case TimePeriod.year:
        return [dateTime.month];
      case TimePeriod.allTime:
        return [dateTime.year];
    }
  }
}

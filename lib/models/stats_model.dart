import 'package:equatable/equatable.dart';

import '../enums/time_period.dart';
import '../state/database_manager.dart';

class StatsModel extends Equatable {
  final DateTime dateTime;
  final int totalMeditationTime;
  final TimePeriod timePeriod;

  const StatsModel(
      {required this.dateTime,
      required this.totalMeditationTime,
      this.timePeriod = TimePeriod.week});

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    final formattedString = map[DatabaseManager.statsDateTime]
        .toString()
        .split('-')
        .reversed
        .join()
        .padRight(7, '01');

    return StatsModel(
      dateTime: DateTime.parse(formattedString),
      totalMeditationTime: map[DatabaseManager.statsTotalMeditationTime],
    );
  }

  @override
  List<Object?> get props {
    switch (timePeriod) {
      case TimePeriod.week:
        return [dateTime.day];
      case TimePeriod.monthly:
        return [dateTime.month];
      case TimePeriod.yearly:
        return [dateTime.month];
    }
  }
}

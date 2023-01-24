import '../state/database_manager.dart';

class StatsModel {
  final DateTime dateTime;
  final int totalMeditationTime;

  StatsModel({required this.dateTime, required this.totalMeditationTime});

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      dateTime: DateTime.parse(map[DatabaseManager.statsDateTime]),
      totalMeditationTime: map[DatabaseManager.statsTotalMeditationTime],
    );
  }
}

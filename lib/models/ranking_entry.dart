import '../utils/formatting.dart';

class RankingEntry {
  final int timeInMilliseconds;
  final DateTime date;

  RankingEntry({
    required this.timeInMilliseconds,
    required this.date,
  });

  String get formattedTime => formatTimeMs(timeInMilliseconds);

  Map<String, dynamic> toJson() {
    return {
      'timeInMilliseconds': timeInMilliseconds,
      'date': date.toIso8601String(),
    };
  }

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      timeInMilliseconds: json['timeInMilliseconds'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

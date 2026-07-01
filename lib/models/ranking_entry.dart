class RankingEntry {
  final int timeInMilliseconds;
  final DateTime date;

  RankingEntry({
    required this.timeInMilliseconds,
    required this.date,
  });

  String get formattedTime {
    final seconds = timeInMilliseconds ~/ 1000;
    final milliseconds = timeInMilliseconds % 1000;
    return '$seconds.${milliseconds.toString().padLeft(3, '0')}s';
  }

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

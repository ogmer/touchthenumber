import '../utils/formatting.dart';

/// オンラインデイリーランキングの1エントリ。
class OnlineRankingEntry {
  final String playerName;
  final int timeInMilliseconds;
  final DateTime date;

  OnlineRankingEntry({
    required this.playerName,
    required this.timeInMilliseconds,
    required this.date,
  });

  factory OnlineRankingEntry.fromJson(Map<String, dynamic> json) {
    return OnlineRankingEntry(
      playerName: (json['player_name'] as String?)?.trim().isNotEmpty == true
          ? json['player_name'] as String
          : 'Player',
      timeInMilliseconds: (json['time_ms'] as num).toInt(),
      date: DateTime.tryParse((json['created_at'] ?? '') as String) ??
          DateTime.now(),
    );
  }

  String get formattedTime => formatTimeMs(timeInMilliseconds);
}

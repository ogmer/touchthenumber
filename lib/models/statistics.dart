import 'game_mode.dart';

class Statistics {
  final Map<GameMode, int> totalGames;
  final Map<GameMode, int> totalTime;
  final Map<GameMode, int> bestTime;

  Statistics({
    required this.totalGames,
    required this.totalTime,
    required this.bestTime,
  });

  factory Statistics.empty() {
    return Statistics(
      totalGames: {
        GameMode.easy: 0,
        GameMode.medium: 0,
        GameMode.hard: 0,
      },
      totalTime: {
        GameMode.easy: 0,
        GameMode.medium: 0,
        GameMode.hard: 0,
      },
      bestTime: {
        GameMode.easy: 0,
        GameMode.medium: 0,
        GameMode.hard: 0,
      },
    );
  }

  int get overallTotalGames =>
      totalGames.values.fold(0, (sum, count) => sum + count);

  int get overallTotalTime => totalTime.values.fold(0, (sum, time) => sum + time);

  int getAverageTime(GameMode mode) {
    final games = totalGames[mode] ?? 0;
    if (games == 0) return 0;
    return (totalTime[mode] ?? 0) ~/ games;
  }

  String formatTime(int milliseconds) {
    if (milliseconds == 0) return '-';
    final seconds = milliseconds ~/ 1000;
    final ms = milliseconds % 1000;
    return '$seconds.${ms.toString().padLeft(3, '0')}s';
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGames': totalGames.map((k, v) => MapEntry(k.name, v)),
      'totalTime': totalTime.map((k, v) => MapEntry(k.name, v)),
      'bestTime': bestTime.map((k, v) => MapEntry(k.name, v)),
    };
  }

  // 改ざん・破損した値（負数や数値以外）は0として読み込む
  static int _readNonNegativeInt(dynamic value) {
    if (value is int && value >= 0) return value;
    return 0;
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalGames: (json['totalGames'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(GameMode.values.byName(k), _readNonNegativeInt(v)),
      ),
      totalTime: (json['totalTime'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(GameMode.values.byName(k), _readNonNegativeInt(v)),
      ),
      bestTime: (json['bestTime'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(GameMode.values.byName(k), _readNonNegativeInt(v)),
      ),
    );
  }
}

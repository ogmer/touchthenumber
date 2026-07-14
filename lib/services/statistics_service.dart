import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_mode.dart';
import '../models/statistics.dart';

class StatisticsService {
  static const String _statisticsKey = 'statistics';
  static const String _dailyCountKey = 'daily_count';
  final SharedPreferences _prefs;

  StatisticsService(this._prefs);

  Future<Statistics> getStatistics() async {
    final jsonString = _prefs.getString(_statisticsKey);

    if (jsonString == null) {
      return Statistics.empty();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Statistics.fromJson(json);
    } catch (e) {
      return Statistics.empty();
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 今日クリアした回数（日付が変わると0に戻る）
  Future<int> getTodayGamesCount() async {
    final jsonString = _prefs.getString(_dailyCountKey);
    if (jsonString == null) return 0;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      if (json['date'] == _todayString()) {
        final count = json['count'];
        // 改ざん・破損した値は0として扱う
        return count is int && count >= 0 ? count : 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _incrementTodayGamesCount() async {
    final count = await getTodayGamesCount();
    await _prefs.setString(
      _dailyCountKey,
      jsonEncode({'date': _todayString(), 'count': count + 1}),
    );
  }

  Future<void> recordGame(GameMode mode, int timeInMilliseconds) async {
    final stats = await getStatistics();

    final newTotalGames = Map<GameMode, int>.from(stats.totalGames);
    newTotalGames[mode] = (newTotalGames[mode] ?? 0) + 1;

    final newTotalTime = Map<GameMode, int>.from(stats.totalTime);
    newTotalTime[mode] = (newTotalTime[mode] ?? 0) + timeInMilliseconds;

    final newBestTime = Map<GameMode, int>.from(stats.bestTime);
    final currentBest = newBestTime[mode] ?? 0;
    if (currentBest == 0 || timeInMilliseconds < currentBest) {
      newBestTime[mode] = timeInMilliseconds;
    }

    final updatedStats = Statistics(
      totalGames: newTotalGames,
      totalTime: newTotalTime,
      bestTime: newBestTime,
    );

    final jsonString = jsonEncode(updatedStats.toJson());
    await _prefs.setString(_statisticsKey, jsonString);

    await _incrementTodayGamesCount();
  }

  Future<void> reset() async {
    await _prefs.remove(_statisticsKey);
    await _prefs.remove(_dailyCountKey);
  }
}

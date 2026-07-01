import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_mode.dart';
import '../models/statistics.dart';

class StatisticsService {
  static const String _statisticsKey = 'statistics';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

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
  }

  Future<void> reset() async {
    await _prefs.remove(_statisticsKey);
  }
}

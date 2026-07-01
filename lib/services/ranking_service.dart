import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';

class RankingService {
  static const int _maxRankings = 10;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _getRankingKey(GameMode mode) => 'ranking_${mode.name}';

  Future<List<RankingEntry>> getRankings(GameMode mode) async {
    final key = _getRankingKey(mode);
    final jsonString = _prefs.getString(key);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => RankingEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRanking(GameMode mode, int timeInMilliseconds) async {
    final rankings = await getRankings(mode);

    final newEntry = RankingEntry(
      timeInMilliseconds: timeInMilliseconds,
      date: DateTime.now(),
    );

    rankings.add(newEntry);
    rankings.sort((a, b) => a.timeInMilliseconds.compareTo(b.timeInMilliseconds));

    if (rankings.length > _maxRankings) {
      rankings.removeRange(_maxRankings, rankings.length);
    }

    final key = _getRankingKey(mode);
    final jsonString = jsonEncode(rankings.map((r) => r.toJson()).toList());
    await _prefs.setString(key, jsonString);
  }

  Future<void> resetRankings(GameMode mode) async {
    final key = _getRankingKey(mode);
    await _prefs.remove(key);
  }

  Future<void> resetAllRankings() async {
    for (final mode in GameMode.values) {
      await resetRankings(mode);
    }
  }
}

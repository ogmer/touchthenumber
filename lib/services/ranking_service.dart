import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';

class RankingService {
  static const int _maxRankings = 10;
  final SharedPreferences _prefs;

  RankingService(this._prefs);

  String _getRankingKey(GameMode mode) => 'ranking_${mode.name}';

  Future<List<RankingEntry>> getRankings(GameMode mode) async {
    final key = _getRankingKey(mode);
    final jsonString = _prefs.getString(key);

    if (jsonString == null) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final entries = <RankingEntry>[];
      for (final json in jsonList) {
        try {
          final entry = RankingEntry.fromJson(json as Map<String, dynamic>);
          // 改ざん・破損したエントリ（0以下のタイムなど）は除外する
          if (entry.timeInMilliseconds > 0) {
            entries.add(entry);
          }
        } catch (e) {
          // 壊れたエントリは読み飛ばす
        }
      }
      entries.sort(
        (a, b) => a.timeInMilliseconds.compareTo(b.timeInMilliseconds),
      );
      return entries.take(_maxRankings).toList();
    } catch (e) {
      // データ全体が壊れている場合は空のランキングとして扱う
      return [];
    }
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
}

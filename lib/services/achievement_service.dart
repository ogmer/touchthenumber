import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/game_mode.dart';
import '../models/statistics.dart';

class AchievementService {
  static const String _achievementsKey = 'achievements';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Achievement>> getAchievements() async {
    final jsonString = _prefs.getString(_achievementsKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Achievement.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> unlockAchievement(AchievementType type) async {
    final achievements = await getAchievements();

    if (achievements.any((a) => a.type == type)) {
      return;
    }

    final newAchievement = Achievement(
      type: type,
      unlockedAt: DateTime.now(),
    );

    achievements.add(newAchievement);

    final jsonString = jsonEncode(achievements.map((a) => a.toJson()).toList());
    await _prefs.setString(_achievementsKey, jsonString);
  }

  bool isUnlocked(AchievementType type, List<Achievement> achievements) {
    return achievements.any((a) => a.type == type);
  }

  Future<List<AchievementType>> checkAchievements(
    Statistics stats,
    GameMode lastPlayedMode,
    int lastTime,
  ) async {
    final achievements = await getAchievements();
    final newAchievements = <AchievementType>[];

    if (stats.overallTotalGames >= 1 &&
        !isUnlocked(AchievementType.firstWin, achievements)) {
      await unlockAchievement(AchievementType.firstWin);
      newAchievements.add(AchievementType.firstWin);
    }

    if (lastTime <= 10000 &&
        !isUnlocked(AchievementType.speed10, achievements)) {
      await unlockAchievement(AchievementType.speed10);
      newAchievements.add(AchievementType.speed10);
    }

    if (lastTime <= 20000 &&
        !isUnlocked(AchievementType.speed20, achievements)) {
      await unlockAchievement(AchievementType.speed20);
      newAchievements.add(AchievementType.speed20);
    }

    if (stats.overallTotalGames >= 10 &&
        !isUnlocked(AchievementType.games10, achievements)) {
      await unlockAchievement(AchievementType.games10);
      newAchievements.add(AchievementType.games10);
    }

    if (stats.overallTotalGames >= 50 &&
        !isUnlocked(AchievementType.games50, achievements)) {
      await unlockAchievement(AchievementType.games50);
      newAchievements.add(AchievementType.games50);
    }

    if (stats.overallTotalGames >= 100 &&
        !isUnlocked(AchievementType.games100, achievements)) {
      await unlockAchievement(AchievementType.games100);
      newAchievements.add(AchievementType.games100);
    }

    final hasPlayedAllModes = GameMode.values
        .every((mode) => (stats.totalGames[mode] ?? 0) > 0);
    if (hasPlayedAllModes &&
        !isUnlocked(AchievementType.allModes, achievements)) {
      await unlockAchievement(AchievementType.allModes);
      newAchievements.add(AchievementType.allModes);
    }

    return newAchievements;
  }
}

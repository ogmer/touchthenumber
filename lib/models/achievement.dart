import 'package:flutter/material.dart';

enum AchievementType {
  firstWin(Icons.celebration),
  speed10(Icons.flash_on),
  speed20(Icons.speed),
  games10(Icons.videogame_asset),
  games50(Icons.emoji_events),
  games100(Icons.stars),
  allModes(Icons.check_circle),
  perfectDay(Icons.wb_sunny);

  // 表示名・説明は多言語対応のため lib/l10n/enum_translations.dart で解決する
  final IconData icon;

  const AchievementType(this.icon);
}

class Achievement {
  final AchievementType type;
  final DateTime unlockedAt;

  Achievement({
    required this.type,
    required this.unlockedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      type: AchievementType.values.byName(json['type'] as String),
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );
  }
}

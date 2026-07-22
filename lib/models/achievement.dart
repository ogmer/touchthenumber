import 'package:flutter/material.dart';

enum AchievementType {
  firstWin(Icons.celebration),
  speed10(Icons.flash_on),
  speed20(Icons.speed),
  games10(Icons.videogame_asset),
  games50(Icons.emoji_events),
  games100(Icons.stars, isHidden: true),
  allModes(Icons.check_circle),
  perfectDay(Icons.wb_sunny);

  // 表示名・説明は多言語対応のため lib/l10n/enum_translations.dart で解決する
  final IconData icon;
  final bool isHidden;

  const AchievementType(this.icon, {this.isHidden = false});

  /// 画面表示用の順序（enumの定義順とは異なる）
  static List<AchievementType> get displayOrder => [
        firstWin,
        speed20,
        games10,
        games50,
        allModes,
        perfectDay,
        speed10, // スピードスターは下の方
        games100, // レジェンド（隠し）は最後
      ];
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

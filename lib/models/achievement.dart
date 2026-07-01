import 'package:flutter/material.dart';

enum AchievementType {
  firstWin('初勝利', '初めてゲームをクリア', Icons.celebration),
  speed10('スピードスター', '10秒以内にクリア', Icons.flash_on),
  speed20('スピードマスター', '20秒以内にクリア', Icons.speed),
  games10('ゲーマー', '10回プレイ', Icons.videogame_asset),
  games50('ベテラン', '50回プレイ', Icons.emoji_events),
  games100('レジェンド', '100回プレイ', Icons.stars),
  allModes('万能プレイヤー', 'すべてのモードでクリア', Icons.check_circle),
  perfectDay('パーフェクトデイ', '1日に10回クリア', Icons.wb_sunny);

  final String title;
  final String description;
  final IconData icon;

  const AchievementType(this.title, this.description, this.icon);
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

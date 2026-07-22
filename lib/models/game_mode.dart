import 'package:flutter/material.dart';

enum GameMode {
  easy(5, '5×5'),
  medium(6, '6×6'),
  hard(7, '7×7');

  final int gridSize;
  final String displayName;

  const GameMode(this.gridSize, this.displayName);

  int get maxNumber => gridSize * gridSize;

  /// 難易度に応じた色を返す
  Color get difficultyColor {
    switch (this) {
      case GameMode.easy:
        // 鮮やかなグリーン（簡単）
        return const Color(0xFF4CAF50);
      case GameMode.medium:
        // 鮮やかなオレンジ（中間）
        return const Color(0xFFFF9800);
      case GameMode.hard:
        // 鮮やかなレッド（難しい）
        return const Color(0xFFF44336);
    }
  }
}

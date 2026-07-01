import 'package:flutter/material.dart';

enum AppTheme {
  blue('ブルー', Colors.blue),
  green('グリーン', Colors.green),
  purple('パープル', Colors.purple),
  orange('オレンジ', Colors.orange),
  red('レッド', Colors.red),
  pink('ピンク', Colors.pink),
  teal('ティール', Colors.teal),
  indigo('インディゴ', Colors.indigo);

  final String displayName;
  final Color color;

  const AppTheme(this.displayName, this.color);

  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: color);
}

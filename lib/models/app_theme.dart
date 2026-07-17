import 'package:flutter/material.dart';

enum AppTheme {
  blue(Colors.blue),
  green(Colors.green),
  purple(Colors.purple),
  orange(Colors.orange),
  red(Colors.red),
  pink(Colors.pink),
  teal(Colors.teal),
  indigo(Colors.indigo);

  // 表示名は多言語対応のため lib/l10n/enum_translations.dart で解決する
  final Color color;

  const AppTheme(this.color);

  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: color);
}

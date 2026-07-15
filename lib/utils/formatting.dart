// タイム・日付の表示整形。各画面・モデルで重複していた実装の共通化

String _two(int n) => n.toString().padLeft(2, '0');

/// ミリ秒を「12.345s」形式にする
String formatTimeMs(int milliseconds) {
  final seconds = milliseconds ~/ 1000;
  final ms = milliseconds % 1000;
  return '$seconds.${ms.toString().padLeft(3, '0')}s';
}

/// 「2026/07/15」形式
String formatDate(DateTime date) =>
    '${date.year}/${_two(date.month)}/${_two(date.day)}';

/// 「2026/07/15 12:34」形式
String formatDateTime(DateTime date) =>
    '${formatDate(date)} ${_two(date.hour)}:${_two(date.minute)}';

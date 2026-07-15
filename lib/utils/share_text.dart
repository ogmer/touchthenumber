import '../models/game_mode.dart';
import '../models/ranking_entry.dart';

/// ランキングの記録をSNS等で共有するためのテキストを組み立てる
String buildRecordShareText({
  required GameMode mode,
  required int rank,
  required RankingEntry entry,
}) {
  return '【Touch the Number】${mode.displayName}モードで '
      '${entry.formattedTime} を記録しました！（ランキング$rank位）\n'
      '数字を1から順にタップする脳トレタイムアタック、あなたも挑戦してみよう！\n'
      '#TouchTheNumber';
}

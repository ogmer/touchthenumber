import '../l10n/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';

/// ランキングの記録をSNS等で共有するためのテキストを組み立てる
String buildRecordShareText({
  required AppLocalizations l10n,
  required GameMode mode,
  required int rank,
  required RankingEntry entry,
}) {
  return l10n.shareRecordText(mode.displayName, entry.formattedTime, rank);
}

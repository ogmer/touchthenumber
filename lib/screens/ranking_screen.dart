import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';
import '../providers.dart';
import '../utils/formatting.dart';
import '../utils/share_text.dart';
import '../widgets/neumorphic.dart';
import '../widgets/reset_confirm_dialog.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  GameMode selectedMode = GameMode.easy;
  List<RankingEntry> rankings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRankings();
  }

  Future<void> _loadRankings() async {
    setState(() {
      isLoading = true;
    });

    final loadedRankings =
        await ref.read(rankingServiceProvider).getRankings(selectedMode);

    setState(() {
      rankings = loadedRankings;
      isLoading = false;
    });
  }

  Future<void> _resetRankings() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showResetConfirmDialog(
      context,
      title: l10n.resetRankingTitle(selectedMode.displayName),
      content: l10n.resetRankingMessage,
    );

    if (confirmed && mounted) {
      await ref.read(rankingServiceProvider).resetRankings(selectedMode);
      await _loadRankings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ranking),
        actions: [
          NeumorphicIconButton(
            icon: Icons.delete_outline,
            onPressed: _resetRankings,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: GameMode.values.map((mode) {
                final isSelected = mode == selectedMode;
                return NeumorphicButton(
                  onPressed: () {
                    setState(() {
                      selectedMode = mode;
                    });
                    _loadRankings();
                  },
                  accent: isSelected,
                  depth: isSelected ? 3 : 5,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  child: Text(mode.displayName),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : rankings.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noRecordsYet,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: rankings.length,
                        itemBuilder: (context, index) {
                          final ranking = rankings[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: NeumorphicContainer(
                              borderRadius: 20,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  _rankBadge(index),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ranking.formattedTime,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formatDateTime(ranking.date),
                                          style:
                                              TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  NeumorphicIconButton(
                                    icon: Icons.share,
                                    size: 40,
                                    tooltip: AppLocalizations.of(context)!
                                        .shareRecord,
                                    onPressed: () =>
                                        _shareRecord(index + 1, ranking),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// 記録をOSの共有シートで共有する。
  /// 共有非対応の環境（一部ブラウザ・デスクトップ）ではクリップボードにコピーする
  Future<void> _shareRecord(int rank, RankingEntry entry) async {
    final text = buildRecordShareText(
      l10n: AppLocalizations.of(context)!,
      mode: selectedMode,
      rank: rank,
      entry: entry,
    );

    try {
      final result = await SharePlus.instance.share(ShareParams(text: text));
      if (result.status == ShareResultStatus.unavailable) {
        await _copyToClipboard(text);
      }
    } catch (e) {
      await _copyToClipboard(text);
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.copiedToClipboard),
        ),
      );
    }
  }

  /// 順位バッジ。上位3位はメダル色で塗り、それ以外は淡色の凹み面に順位を表示する。
  Widget _rankBadge(int index) {
    final medalColor = switch (index) {
      0 => Colors.amber,
      1 => Colors.blueGrey,
      2 => Colors.brown,
      _ => null,
    };

    if (medalColor != null) {
      return NeumorphicContainer(
        shape: BoxShape.circle,
        depth: 4,
        color: medalColor,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }

    return NeumorphicContainer(
      shape: BoxShape.circle,
      style: NeumorphicStyle.pressed,
      depth: 5,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';
import '../providers.dart';
import '../utils/formatting.dart';
import '../utils/share_text.dart';
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
    final confirmed = await showResetConfirmDialog(
      context,
      title: '${selectedMode.displayName}のランキングをリセット',
      content: 'このモードのすべてのランキングをリセットしますか？\nこの操作は取り消せません。',
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
        title: const Text('ランキング'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _resetRankings,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: GameMode.values.map((mode) {
                final isSelected = mode == selectedMode;
                final colorScheme = Theme.of(context).colorScheme;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMode = mode;
                    });
                    _loadRankings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Colors.orange
                        : colorScheme.surfaceContainerHighest,
                    foregroundColor: isSelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                    elevation: isSelected ? 3 : 0,
                  ),
                  child: Text(mode.displayName),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : rankings.isEmpty
                    ? const Center(
                        child: Text(
                          'まだ記録がありません',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: rankings.length,
                        itemBuilder: (context, index) {
                          final ranking = rankings[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getRankColor(index),
                                foregroundColor: Colors.white,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                ranking.formattedTime,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formatDateTime(ranking.date),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.share),
                                tooltip: '記録を共有',
                                onPressed: () =>
                                    _shareRecord(index + 1, ranking),
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
        const SnackBar(content: Text('記録をクリップボードにコピーしました')),
      );
    }
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

}

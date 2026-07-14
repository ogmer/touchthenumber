import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_mode.dart';
import '../models/ranking_entry.dart';
import '../providers.dart';

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${selectedMode.displayName}のランキングをリセット'),
        content: const Text('このモードのすべてのランキングをリセットしますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('リセット'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(rankingServiceProvider).resetRankings(selectedMode);
      await _loadRankings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _resetRankings,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: GameMode.values.map((mode) {
                final isSelected = mode == selectedMode;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMode = mode;
                    });
                    _loadRankings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.orange : Colors.grey,
                    foregroundColor: Colors.white,
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
                                _formatDate(ranking.date),
                                style: TextStyle(color: Colors.grey[600]),
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

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

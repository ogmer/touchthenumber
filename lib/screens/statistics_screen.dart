import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_mode.dart';
import '../models/statistics.dart';
import '../providers.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  Statistics? statistics;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      isLoading = true;
    });

    final stats = await ref.read(statisticsServiceProvider).getStatistics();

    setState(() {
      statistics = stats;
      isLoading = false;
    });
  }

  Future<void> _resetStatistics() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('統計情報をリセット'),
        content: const Text('すべての統計情報をリセットしますか？\nこの操作は取り消せません。'),
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
      await ref.read(statisticsServiceProvider).reset();
      await _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('統計情報'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetStatistics,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : statistics == null
              ? const Center(child: Text('データがありません'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverallStats(),
                        const SizedBox(height: 24),
                        const Text(
                          '難易度別統計',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...GameMode.values.map((mode) => _buildModeStats(mode)),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildOverallStats() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '全体統計',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              '総プレイ回数',
              '${statistics!.overallTotalGames}回',
              Icons.videogame_asset,
            ),
            _buildStatRow(
              '総プレイ時間',
              statistics!.formatTime(statistics!.overallTotalTime),
              Icons.timer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeStats(GameMode mode) {
    final games = statistics!.totalGames[mode] ?? 0;
    final bestTime = statistics!.bestTime[mode] ?? 0;
    final avgTime = statistics!.getAverageTime(mode);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mode.displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatRow('プレイ回数', '$games回', Icons.play_arrow),
            _buildStatRow(
              'ベストタイム',
              statistics!.formatTime(bestTime),
              Icons.star,
            ),
            _buildStatRow(
              '平均タイム',
              statistics!.formatTime(avgTime),
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

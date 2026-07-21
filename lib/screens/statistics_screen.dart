import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_mode.dart';
import '../l10n/app_localizations.dart';
import '../models/statistics.dart';
import '../providers.dart';
import '../widgets/neumorphic.dart';
import '../widgets/reset_confirm_dialog.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showResetConfirmDialog(
      context,
      title: l10n.resetStatsTitle,
      content: l10n.resetStatsMessage,
    );

    if (confirmed && mounted) {
      await ref.read(statisticsServiceProvider).reset();
      await _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        actions: [
          NeumorphicIconButton(
            icon: Icons.refresh,
            onPressed: _resetStatistics,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : statistics == null
              ? Center(child: Text(l10n.noData))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverallStats(l10n),
                        const SizedBox(height: 24),
                        Text(
                          l10n.statsByDifficulty,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...GameMode.values
                            .map((mode) => _buildModeStats(l10n, mode)),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildOverallStats(AppLocalizations l10n) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(20.0),
      depth: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overallStats,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            l10n.totalPlays,
            l10n.timesCount(statistics!.overallTotalGames),
            Icons.videogame_asset,
          ),
          _buildStatRow(
            l10n.totalPlayTime,
            statistics!.formatTime(statistics!.overallTotalTime),
            Icons.timer,
          ),
        ],
      ),
    );
  }

  Widget _buildModeStats(AppLocalizations l10n, GameMode mode) {
    final games = statistics!.totalGames[mode] ?? 0;
    final bestTime = statistics!.bestTime[mode] ?? 0;
    final avgTime = statistics!.getAverageTime(mode);
    final accent = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mode.displayName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              l10n.playCount,
              l10n.timesCount(games),
              Icons.play_arrow,
            ),
            _buildStatRow(
              l10n.bestTime,
              statistics!.formatTime(bestTime),
              Icons.star,
            ),
            _buildStatRow(
              l10n.averageTime,
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

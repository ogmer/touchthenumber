import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/online_ranking_entry.dart';
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
  late PageController _pageController;

  // ローカルランキング
  List<RankingEntry> rankings = [];
  bool isLoading = true;

  // オンライン（今日の）ランキング
  List<OnlineRankingEntry> onlineEntries = [];
  bool onlineLoading = false;
  bool onlineError = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: GameMode.values.indexOf(selectedMode));
    _loadRankings();
    if (ref.read(onlineEnabledProvider)) _loadOnline();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadRankings() async {
    setState(() => isLoading = true);
    final loaded =
        await ref.read(rankingServiceProvider).getRankings(selectedMode);
    if (!mounted) return;
    setState(() {
      rankings = loaded;
      isLoading = false;
    });
  }

  Future<void> _loadOnline() async {
    final service = ref.read(onlineRankingServiceProvider);
    if (service == null) return;
    setState(() {
      onlineLoading = true;
      onlineError = false;
    });
    try {
      final entries = await service.getDailyRankings(selectedMode);
      if (!mounted) return;
      setState(() {
        onlineEntries = entries;
        onlineLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        onlineError = true;
        onlineLoading = false;
      });
    }
  }

  void _selectMode(GameMode mode) {
    final pageIndex = GameMode.values.indexOf(mode);
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => selectedMode = mode);
    _loadRankings();
    if (ref.read(onlineEnabledProvider)) _loadOnline();
  }

  void _onPageChanged(int index) {
    final mode = GameMode.values[index];
    if (mode != selectedMode) {
      setState(() => selectedMode = mode);
      _loadRankings();
      if (ref.read(onlineEnabledProvider)) _loadOnline();
    }
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
    final l10n = AppLocalizations.of(context)!;
    final onlineEnabled = ref.watch(onlineEnabledProvider);

    final modeSelector = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: GameMode.values.map((mode) {
          final isSelected = mode == selectedMode;
          return NeumorphicButton(
            onPressed: () => _selectMode(mode),
            accent: isSelected,
            depth: isSelected ? 3 : 5,
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Text(mode.displayName),
          );
        }).toList(),
      ),
    );

    final actions = [
      NeumorphicIconButton(
        icon: Icons.delete_outline,
        onPressed: _resetRankings,
      ),
      const SizedBox(width: 12),
    ];

    // オンライン未設定なら従来どおりローカルのみ（タブなし）
    if (!onlineEnabled) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ranking), actions: actions),
        body: Column(
          children: [
            modeSelector,
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: GameMode.values.length,
                itemBuilder: (context, index) {
                  return _buildLocalList(l10n);
                },
              ),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.ranking),
          actions: actions,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.rankingLocalTab),
              Tab(text: l10n.rankingOnlineTab),
            ],
          ),
        ),
        body: Column(
          children: [
            modeSelector,
            Expanded(
              child: TabBarView(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: GameMode.values.length,
                    itemBuilder: (context, index) {
                      return _buildLocalList(l10n);
                    },
                  ),
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: GameMode.values.length,
                    itemBuilder: (context, index) {
                      return _buildOnlineList(l10n);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalList(AppLocalizations l10n) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (rankings.isEmpty) {
      return Center(
        child: Text(l10n.noRecordsYet, style: const TextStyle(fontSize: 18)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final ranking = rankings[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: NeumorphicContainer(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _rankBadge(index),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                NeumorphicIconButton(
                  icon: Icons.share,
                  size: 40,
                  tooltip: l10n.shareRecord,
                  onPressed: () => _shareRecord(index + 1, ranking),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnlineList(AppLocalizations l10n) {
    if (onlineLoading) return const Center(child: CircularProgressIndicator());
    if (onlineError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.onlineUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    if (onlineEntries.isEmpty) {
      return Center(
        child: Text(l10n.noRecordsYet, style: const TextStyle(fontSize: 18)),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadOnline,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: onlineEntries.length,
        itemBuilder: (context, index) {
          final e = onlineEntries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NeumorphicContainer(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _rankBadge(index),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.playerName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          e.formattedTime,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

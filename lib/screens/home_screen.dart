import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../l10n/enum_translations.dart';
import '../models/game_mode.dart';
import '../providers.dart';
import '../widgets/neumorphic.dart';
import '../widgets/sound_toggle_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    // Webはオートプレイ制限で最初のユーザー操作前に音を鳴らせない。
    // ここで再生を試みると再生状態だけが「再生中」になり、_ensureTitleBgmの
    // 再試行がスキップされてしまうため、Webでは最初のタップまで開始を待つ。
    if (!kIsWeb) {
      ref.read(audioServiceProvider).startTitleBgm();
    }
  }

  /// Webのオートプレイ制限対策: ユーザー操作をきっかけに未再生なら開始する
  void _ensureTitleBgm() {
    final audio = ref.read(audioServiceProvider);
    if (!audio.isBgmPlaying) {
      audio.startTitleBgm();
    }
  }

  /// ゲーム画面へ。タイトルBGMを止め、戻ってきたら再開する
  Future<void> _startGame(GameMode mode) async {
    final audio = ref.read(audioServiceProvider);
    await audio.stopBgm();
    if (!mounted) return;
    await context.push('/game/${mode.name}');
    if (!mounted) return;
    audio.startTitleBgm();
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  // ランキング・統計・実績への遷移ボタン。
  // 面はニューモフィズムの淡色で統一し、アイコンだけ色分けして識別しやすくする
  Widget _menuButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onPressed,
  }) {
    return NeumorphicButton(
      onPressed: onPressed,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 160),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // 各要素を上から順番にバウンドさせながら登場させる
  Widget _popIn(int order, int total, Widget child) {
    final start = (order / (total + 2)).clamp(0.0, 0.8);
    final animation = CurvedAnimation(
      parent: _popController,
      curve: Interval(
        start,
        (start + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _popController,
        curve: Interval(start, (start + 0.4).clamp(0.0, 1.0)),
      ),
      child: ScaleTransition(scale: animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Webのオートプレイ制限対策として、画面のどこか（AppBarのアイコン含む）に
    // 最初に触れたタイミングでタイトルBGMを開始する
    return Listener(
      onPointerDown: (_) => _ensureTitleBgm(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
        ),
        // 設定系ボタン（ミュート・遊び方・設定）は画面下部に中央寄せで配置する
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SoundToggleButton(),
                const SizedBox(width: 24),
                NeumorphicIconButton(
                  icon: Icons.help_outline,
                  onPressed: () => context.push('/tutorial'),
                ),
                const SizedBox(width: 24),
                NeumorphicIconButton(
                  icon: Icons.settings,
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
          ),
        ),
        // 内容が画面より小さいときは中央、はみ出すときはスクロールできるようにする
        // （難易度ラベル追加で縦に伸びても、小さい端末で見切れないようにするため）
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _popIn(
                      0,
                      7,
                      Text(
                        l10n.selectGameMode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...GameMode.values.indexed.map(
                      (entry) => _popIn(
                        entry.$1 + 1,
                        7,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          // ボタンにはモード名だけを載せ、難易度ラベルはボタンの上に置く
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                entry.$2.difficultyLabel(l10n),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              NeumorphicButton(
                                onPressed: () => _startGame(entry.$2),
                                accent: true,
                                borderRadius: 24,
                                depth: 7,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 120,
                                  ),
                                  child: Text(
                                    entry.$2.displayName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _popIn(
                      4,
                      7,
                      _menuButton(
                        icon: Icons.emoji_events,
                        iconColor: Colors.orange,
                        label: l10n.ranking,
                        onPressed: () => context.push('/ranking'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _popIn(
                      5,
                      7,
                      _menuButton(
                        icon: Icons.bar_chart,
                        iconColor: Colors.green,
                        label: l10n.statistics,
                        onPressed: () => context.push('/statistics'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _popIn(
                      6,
                      7,
                      _menuButton(
                        icon: Icons.military_tech,
                        iconColor: Colors.purple,
                        label: l10n.achievements,
                        onPressed: () => context.push('/achievements'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

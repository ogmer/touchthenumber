import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/game_mode.dart';
import '../providers.dart';

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
    // タイトルBGMを開始（Webはオートプレイ制限で失敗することがあるため、
    // 最初のタップ時にも_ensureTitleBgmで再試行する）
    ref.read(audioServiceProvider).startTitleBgm();
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

  // 各要素を上から順番にバウンドさせながら登場させる
  Widget _popIn(int order, int total, Widget child) {
    final start = (order / (total + 2)).clamp(0.0, 0.8);
    final animation = CurvedAnimation(
      parent: _popController,
      curve: Interval(start, (start + 0.4).clamp(0.0, 1.0),
          curve: Curves.easeOutBack),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touch the Number'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push('/tutorial'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Listener(
        // Webのオートプレイ制限で初回のBGM再生が失敗した場合、
        // 画面のどこかに触れたタイミングで開始する
        onPointerDown: (_) => _ensureTitleBgm(),
        behavior: HitTestBehavior.translucent,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _popIn(
              0,
              7,
              const Text(
                'ゲームモードを選択',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            ...GameMode.values.indexed.map((entry) => _popIn(
                  entry.$1 + 1,
                  7,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => _startGame(entry.$2),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 60),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: Text(entry.$2.displayName),
                    ),
                  ),
                )),
            const SizedBox(height: 40),
            _popIn(
              4,
              7,
              ElevatedButton.icon(
                onPressed: () => context.push('/ranking'),
                icon: const Icon(Icons.emoji_events),
                label: const Text('ランキング'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _popIn(
              5,
              7,
              ElevatedButton.icon(
                onPressed: () => context.push('/statistics'),
                icon: const Icon(Icons.bar_chart),
                label: const Text('統計情報'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _popIn(
              6,
              7,
              ElevatedButton.icon(
                onPressed: () => context.push('/achievements'),
                icon: const Icon(Icons.military_tech),
                label: const Text('アチーブメント'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

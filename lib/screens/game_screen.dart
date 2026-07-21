import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';
import '../l10n/enum_translations.dart';
import '../models/game_mode.dart';
import '../models/achievement.dart';
import '../providers.dart';
import '../services/audio_service.dart';
import '../utils/formatting.dart';
import '../widgets/neumorphic.dart';
import '../widgets/sound_toggle_button.dart';

class GameScreen extends ConsumerStatefulWidget {
  final GameMode gameMode;

  const GameScreen({super.key, required this.gameMode});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

/// グリッド全体（タイル＋隙間）が利用可能領域に収まるセルの一辺を返す
@visibleForTesting
double calcCellSize({
  required double availableWidth,
  required double availableHeight,
  required int gridSize,
  double spacing = 8.0,
}) {
  final totalSpacing = spacing * (gridSize - 1);
  final fit = min(
    (availableWidth - totalSpacing) / gridSize,
    (availableHeight - totalSpacing) / gridSize,
  );
  return fit.clamp(28.0, 120.0);
}

class _GameScreenState extends ConsumerState<GameScreen>
    with SingleTickerProviderStateMixin {
  late List<int> numbers;
  // 現在の目標数字。各タイルはこれを購読せず、タップ時に値を読むだけなので、
  // 数字を進めても盤面全体は再ビルドされない（ヘッダの「次」表示だけが更新される）
  final ValueNotifier<int> _currentNumber = ValueNotifier(1);
  // ゲームをやり直すたびに +1。タイルのKeyに含めることで、内部状態（タップ済み等）を
  // 確実にリセットする
  int _generation = 0;
  // 経過時間はValueNotifierで時刻表示だけを局所更新する
  // （setStateで33msごとにグリッド全体を再ビルドしない）
  final ValueNotifier<int> _elapsedMs = ValueNotifier(0);
  final Stopwatch _stopwatch = Stopwatch();
  Timer? timer;
  bool isPlaying = false;
  // null になったらカウントダウン終了・入力受付開始。
  // 'ready'→'3'→'2'→'1'→'go' の順で切り替える
  String? _countdownStep;
  late AudioService audioService;
  late ConfettiController _confettiController;
  late AnimationController _entranceController;
  // タイル登場アニメーションはビルドごとに作らず一度だけ生成して使い回す
  late final List<CurvedAnimation> _entranceAnimations;

  @override
  void initState() {
    super.initState();
    audioService = ref.read(audioServiceProvider);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _entranceAnimations = List.generate(widget.gameMode.maxNumber, (index) {
      final gridSize = widget.gameMode.gridSize;
      final diagonal = (index ~/ gridSize) + (index % gridSize);
      final maxDiagonal = 2 * (gridSize - 1);
      final start = maxDiagonal == 0 ? 0.0 : (diagonal / maxDiagonal) * 0.55;
      return CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, (start + 0.45).clamp(0.0, 1.0),
            curve: Curves.elasticOut),
      );
    });
    _initGame();
    _startCountdown();
  }

  void _initGame() {
    numbers = List.generate(widget.gameMode.maxNumber, (index) => index + 1);
    numbers.shuffle(Random());
    _currentNumber.value = 1;
    // 世代を進めてタイルのKeyを変え、内部状態（タップ済み・アニメ中など）をリセットする
    _generation++;
    _elapsedMs.value = 0;
    isPlaying = false;
    _stopwatch.reset();
    // カウントダウン中はタイルをフルサイズ(value=1)で不可視に描画し、影の
    // ラスタライズを先に済ませておく（下の build 参照）。登場の弾みアニメーション
    // 自体はカウントダウン終了時（_beginPlay）に 0 から開始する
    _entranceController.value = 1;
  }

  /// 「準備OK？」→3→2→1→「スタート」の順で表示し、終わったらゲームを開始する。
  /// この間はタイルをタップできない
  Future<void> _startCountdown() async {
    const steps = ['ready', '3', '2', '1', 'go'];
    for (final step in steps) {
      if (!mounted) return;
      setState(() => _countdownStep = step);
      await Future.delayed(
        Duration(milliseconds: step == 'go' ? 500 : 700),
      );
    }
    if (!mounted) return;
    setState(() => _countdownStep = null);
    _beginPlay();
  }

  void _beginPlay() {
    isPlaying = true;
    // カウントダウンが終わってからタイルを対角線状に弾ませながら登場させる
    _entranceController.forward(from: 0);
    _startTimer();
    audioService.startGameBgm();
  }

  void _startTimer() {
    _stopwatch.start();
    timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      _elapsedMs.value = _stopwatch.elapsedMilliseconds;
    });
  }

  void _stopTimer() {
    timer?.cancel();
    _stopwatch.stop();
    _elapsedMs.value = _stopwatch.elapsedMilliseconds;
  }

  /// 正解タイルがタップされたときにタイルから呼ばれる。
  /// 目標数字を進め、完了なら締める。タップされたタイルの見た目更新はタイル側で
  /// 完結するため、ここで盤面全体を再ビルドしない（ヘッダの「次」だけが更新される）。
  void _onCorrect() {
    audioService.playCorrectSound();
    final next = _currentNumber.value + 1;
    _currentNumber.value = next;
    if (next > widget.gameMode.maxNumber) {
      _finishGame();
    }
  }

  /// 誤ったタイルがタップされたときにタイルから呼ばれる。
  void _onWrong() {
    audioService.playErrorSound();
  }

  /// 今タップできるか（カウントダウン中は不可）。タイルの判定に渡す。
  bool _canTap() => _countdownStep == null;

  Future<void> _finishGame() async {
    _stopTimer();
    final finalTime = _elapsedMs.value;

    final statisticsService = ref.read(statisticsServiceProvider);
    final rankingService = ref.read(rankingServiceProvider);

    // 記録を書き込む前に、更新前のベストタイムを控える（0 は記録なし＝初クリア）
    final prevBest =
        (await statisticsService.getStatistics()).bestTime[widget.gameMode] ??
            0;
    final isNewBest = prevBest == 0 || finalTime < prevBest;

    _confettiController.play();
    await audioService.stopBgm();
    audioService.playCompleteSound();

    await rankingService.addRanking(widget.gameMode, finalTime);
    await statisticsService.recordGame(widget.gameMode, finalTime);

    // オンラインデイリーランキングへ投稿（設定済み かつ ニックネーム入力済みのとき）。
    // 失敗してもゲームのクリア処理は止めない（fire-and-forget）
    _submitOnline(finalTime);

    // 今回のタイムがランキング（上位10）で何位に入ったか
    final rankings = await rankingService.getRankings(widget.gameMode);
    int? rank;
    for (var i = 0; i < rankings.length; i++) {
      if (rankings[i].timeInMilliseconds == finalTime) {
        rank = i + 1;
        break;
      }
    }

    final stats = await statisticsService.getStatistics();
    final todayGamesCount = await statisticsService.getTodayGamesCount();
    final newAchievements =
        await ref.read(achievementServiceProvider).checkAchievements(
      stats,
      widget.gameMode,
      finalTime,
      todayGamesCount,
    );

    if (!mounted) return;
    _showCompleteDialog(
      newAchievements,
      isNewBest: isNewBest,
      hadPreviousBest: prevBest > 0,
      // 正なら「ベストまであと」、負なら「ベストをどれだけ縮めたか」
      diffToBestMs: prevBest > 0 ? finalTime - prevBest : null,
      rank: rank,
    );

    // クリア直後の節目でストアレビューを依頼する（表示判断はOS任せ）
    ref.read(reviewServiceProvider).maybeRequestReview(stats.overallTotalGames);
  }

  /// オンラインランキングへ投稿する。オンライン未設定・ニックネーム未入力なら何もしない。
  /// エラーはゲーム進行に影響しないよう握りつぶす。
  Future<void> _submitOnline(int finalTime) async {
    final online = ref.read(onlineRankingServiceProvider);
    final name = ref.read(playerNameProvider).trim();
    if (online == null || name.isEmpty) return;
    try {
      await online.submitScore(
        mode: widget.gameMode,
        timeMs: finalTime,
        playerName: name,
      );
    } catch (e) {
      // 投稿失敗は無視（次回のクリアで再投稿される）
    }
  }

  void _showCompleteDialog(
    List<AchievementType> newAchievements, {
    required bool isNewBest,
    required bool hadPreviousBest,
    int? diffToBestMs,
    int? rank,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final timeString = formatTimeMs(_elapsedMs.value);

    // 3秒以内の僅差でベストに届かなかったときだけ「あと○秒」で悔しさを煽る
    final showNearMiss = !isNewBest &&
        diffToBestMs != null &&
        diffToBestMs > 0 &&
        diffToBestMs <= 3000;
    // ベストを更新できたときの短縮幅（2回目以降のみ）
    final improvedMs =
        isNewBest && hadPreviousBest && diffToBestMs != null && diffToBestMs < 0
            ? -diffToBestMs
            : null;
    // 上位3位はメダル色、それ以外はアクセント色
    final Color rankColor = switch (rank) {
      1 => Colors.amber,
      2 => Colors.blueGrey,
      3 => Colors.brown,
      _ => colorScheme.primary,
    };

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // バネのように弾んで登場させる
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
        title: Text(l10n.clearTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.timeLabel(timeString)),
            // 自己ベスト更新の祝福（縮めた幅も表示して達成感を強める）
            if (isNewBest) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    l10n.newBestRecord,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              if (improvedMs != null)
                Text(
                  '-${formatTimeMs(improvedMs)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
            ]
            // 惜しくも更新ならず（僅差のときだけ煽る）
            else if (showNearMiss)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.behindBest(formatTimeMs(diffToBestMs)),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            // ランキング入りした順位バッジ
            if (rank != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.leaderboard, color: rankColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      l10n.rankLabel(rank),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: rankColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (newAchievements.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.newAchievements,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 8),
              ...newAchievements.map(
                (type) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(type.icon, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          type.title(l10n),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initGame();
              });
              _startCountdown();
            },
            child: Text(l10n.playAgain),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.backToHome),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int index, double fontSize) {
    // タイルを独立ウィジェット化し、タップ状態（タップ済み・アニメ中・揺れ中）を
    // タイル自身が持つ。こうするとタップ時に再ビルドされるのはそのタイル1枚だけになり、
    // 盤面全体（最大49枚）の再ビルドがなくなる＝処理負荷が大きく下がる
    return _NumberTile(
      key: ValueKey('$_generation-$index'),
      number: numbers[index],
      fontSize: fontSize,
      entranceAnimation: _entranceAnimations[index],
      currentNumber: _currentNumber,
      canTap: _canTap,
      onCorrect: _onCorrect,
      onWrong: _onWrong,
    );
  }

  @override
  void dispose() {
    _stopTimer();
    _elapsedMs.dispose();
    _currentNumber.dispose();
    _confettiController.dispose();
    for (final animation in _entranceAnimations) {
      animation.dispose();
    }
    _entranceController.dispose();
    // BGMの切り替えはホーム画面側が行う（disposeは画面遷移アニメーション後に
    // 呼ばれるため、ここで止めるとタイトルBGMの再開と競合する）
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameMode.displayName),
        actions: const [SoundToggleButton()],
      ),
      body: Stack(
        children: [
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: NeumorphicContainer(
              borderRadius: 28,
              depth: 6,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.nextLabel,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      // 目標数字の表示はこのTextだけを局所更新する
                      // （タップで盤面全体を再ビルドしない）
                      ValueListenableBuilder<int>(
                        valueListenable: _currentNumber,
                        builder: (context, current, _) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                            child: child,
                          ),
                          child: Text(
                            '${min(current, widget.gameMode.maxNumber)}',
                            key: ValueKey(current),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 33msごとの時刻更新はこのTextだけを再ビルドする
                  ValueListenableBuilder<int>(
                    valueListenable: _elapsedMs,
                    builder: (context, elapsed, _) => Text(
                      AppLocalizations.of(context)!
                          .timeLabel(formatTimeMs(elapsed)),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 利用可能なスペースを計算
                final availableWidth = constraints.maxWidth - 32;
                final availableHeight = constraints.maxHeight - 32;

                // グリッド全体（隙間込み）が収まるセルサイズを計算
                final cellSize = calcCellSize(
                  availableWidth: availableWidth,
                  availableHeight: availableHeight,
                  gridSize: widget.gameMode.gridSize,
                );

                // フォントサイズを動的に計算
                final fontSize = (cellSize * 0.4).clamp(12.0, 48.0);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: cellSize * widget.gameMode.gridSize + 8 * (widget.gameMode.gridSize - 1),
                      height: cellSize * widget.gameMode.gridSize + 8 * (widget.gameMode.gridSize - 1),
                      // カウントダウン中もタイルを「ほぼ透明」で描画しておくことで、
                      // 影のラスタライズを事前に済ませ、「スタート」時のカクつきを防ぐ。
                      // opacity を完全な 0 にすると描画自体がスキップされ事前ウォーム
                      // アップにならないため、視認できない極小値にする（上にカウント
                      // ダウンの暗幕が重なるので数字は見えない）
                      child: Opacity(
                        opacity: _countdownStep == null ? 1.0 : 0.004,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.gameMode.gridSize,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: widget.gameMode.maxNumber,
                          itemBuilder: (context, index) =>
                              _buildTile(index, fontSize),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          if (_countdownStep != null)
            Positioned.fill(
              // 暗幕は盤面（影のウォームアップ用に極薄で描いているタイル）を
              // 完全に隠せる濃さにする。薄いと数字が透けて見えてしまう
              child: Container(
                color: Colors.black.withValues(alpha: 0.88),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.elasticOut,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Text(
                      _countdownLabel(
                        _countdownStep!,
                        AppLocalizations.of(context)!,
                      ),
                      key: ValueKey(_countdownStep),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _countdownLabel(String step, AppLocalizations l10n) => switch (step) {
        'ready' => l10n.countdownReady,
        'go' => l10n.countdownGo,
        _ => step,
      };
}

/// 盤面の1マス。タップ状態（未タップ・拡大アニメ中・揺れ中）を自身で保持し、
/// タップ時にこのタイルだけが再ビルドされるようにする。目標数字の進行や音・完了判定は
/// 親から渡されたコールバックに委ねる。
class _NumberTile extends StatefulWidget {
  final int number;
  final double fontSize;
  final Animation<double> entranceAnimation;

  /// 目標数字。購読はせず、タップ時に値を読んで正誤判定するだけ。
  final ValueNotifier<int> currentNumber;

  /// 今タップを受け付けるか（カウントダウン中は false）。
  final bool Function() canTap;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const _NumberTile({
    super.key,
    required this.number,
    required this.fontSize,
    required this.entranceAnimation,
    required this.currentNumber,
    required this.canTap,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  State<_NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<_NumberTile> {
  bool _tapped = false;
  bool _animating = false;
  bool _shaking = false;
  int _shakeSeed = 0;

  void _handleTap() {
    if (_tapped || !widget.canTap()) return;
    if (widget.currentNumber.value == widget.number) {
      setState(() {
        _tapped = true;
        _animating = true;
      });
      widget.onCorrect();
      // 拡大→フェードで消える演出。このタイルの中だけで完結する
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _animating = false);
      });
    } else {
      setState(() {
        _shaking = true;
        _shakeSeed++;
      });
      widget.onWrong();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 跳ねている最中は「アクティブな見た目」を保ち、跳ね終わってから消す
    final showActive = !_tapped || _animating;

    // タップ後: 一瞬拡大してからふわっと消える。
    // 未タップは浮き上がったアクセント色の面。タップ済みは opacity で消えるので、
    // 見えない影(inset blur)を描き続けないよう flat にして描画コストを抑える
    Widget visual = AnimatedScale(
      scale: _animating ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _tapped && !_animating ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: NeumorphicContainer(
          borderRadius: 16,
          depth: 5,
          color: showActive ? colorScheme.primary : null,
          style: showActive ? NeumorphicStyle.raised : NeumorphicStyle.flat,
          child: Center(
            child: Text(
              widget.number.toString(),
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: showActive
                    ? Colors.white
                    : colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ),
    );

    // ミスタップ: 左右にプルプル震える（見た目だけ揺らし、タップ判定は動かさない）
    if (_shaking) {
      visual = TweenAnimationBuilder<double>(
        key: ValueKey('shake_$_shakeSeed'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        onEnd: () {
          if (mounted && _shaking) setState(() => _shaking = false);
        },
        builder: (context, t, child) {
          final dx = sin(t * pi * 4) * 8 * (1 - t);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: visual,
      );
    }

    // タップ判定は固定サイズのセル全体で行う。
    // GestureDetector を拡大・登場・揺れの各アニメーションより外側に置くことで、
    // ヒット領域がアニメーションで伸縮・移動して判定がブレるのを防ぐ。
    // HitTestBehavior.opaque でセル矩形全体（角丸の外側や透明部分も含む）を反応させる。
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _tapped ? null : _handleTap,
        child: ScaleTransition(
          scale: widget.entranceAnimation,
          child: visual,
        ),
      ),
    );
  }
}

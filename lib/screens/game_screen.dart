import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../models/game_mode.dart';
import '../models/achievement.dart';
import '../providers.dart';
import '../services/audio_service.dart';
import '../utils/formatting.dart';
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
  late List<bool> tapped;
  int currentNumber = 1;
  // 経過時間はValueNotifierで時刻表示だけを局所更新する
  // （setStateで33msごとにグリッド全体を再ビルドしない）
  final ValueNotifier<int> _elapsedMs = ValueNotifier(0);
  final Stopwatch _stopwatch = Stopwatch();
  Timer? timer;
  bool isPlaying = false;
  late AudioService audioService;
  Set<int> animatingNumbers = {};
  int? shakingIndex;
  int shakeCount = 0;
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
  }

  void _initGame() {
    numbers = List.generate(widget.gameMode.maxNumber, (index) => index + 1);
    numbers.shuffle(Random());
    tapped = List.generate(widget.gameMode.maxNumber, (index) => false);
    animatingNumbers.clear();
    shakingIndex = null;
    currentNumber = 1;
    _elapsedMs.value = 0;
    isPlaying = false;
    _stopwatch.reset();
    // タイルを対角線状に弾ませながら登場させる
    _entranceController.forward(from: 0);
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

  void _onNumberTap(int index) {
    if (!isPlaying) {
      isPlaying = true;
      _startTimer();
      audioService.startGameBgm();
    }

    final tappedNumber = numbers[index];

    if (tappedNumber == currentNumber) {
      setState(() {
        tapped[index] = true;
        animatingNumbers.add(index);
        currentNumber++;
      });

      audioService.playCorrectSound();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            animatingNumbers.remove(index);
          });
        }
      });

      if (currentNumber > widget.gameMode.maxNumber) {
        _finishGame();
      }
    } else {
      setState(() {
        shakingIndex = index;
        shakeCount++;
      });
      audioService.playErrorSound();
    }
  }

  Future<void> _finishGame() async {
    _stopTimer();
    final finalTime = _elapsedMs.value;

    _confettiController.play();
    await audioService.stopBgm();
    audioService.playCompleteSound();

    final statisticsService = ref.read(statisticsServiceProvider);
    await ref.read(rankingServiceProvider).addRanking(widget.gameMode, finalTime);
    await statisticsService.recordGame(widget.gameMode, finalTime);

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
    _showCompleteDialog(newAchievements);

    // クリア直後の節目でストアレビューを依頼する（表示判断はOS任せ）
    ref.read(reviewServiceProvider).maybeRequestReview(stats.overallTotalGames);
  }

  void _showCompleteDialog(List<AchievementType> newAchievements) {
    final timeString = formatTimeMs(_elapsedMs.value);

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
        title: const Text('クリア！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('タイム: $timeString'),
            if (newAchievements.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                '🏆 新しいアチーブメント！',
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
                          type.title,
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
            },
            child: const Text('もう一度'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int index, double fontSize) {
    final number = numbers[index];
    final isTapped = tapped[index];
    final isAnimating = animatingNumbers.contains(index);
    final colorScheme = Theme.of(context).colorScheme;

    // 跳ねている最中は「アクティブな見た目」を保ち、跳ね終わってから消す
    final showActive = !isTapped || isAnimating;

    // タップ後: 一瞬拡大してからふわっと消える
    Widget tile = AnimatedScale(
      scale: isAnimating ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isTapped && !isAnimating ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Material(
          color: showActive ? colorScheme.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          elevation: showActive ? 3 : 0,
          shadowColor: colorScheme.primary.withValues(alpha: 0.4),
          child: InkWell(
            onTap: isTapped ? null : () => _onNumberTap(index),
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: showActive ? Colors.white : Colors.grey[500],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // ミスタップ: 左右にプルプル震える
    if (shakingIndex == index) {
      tile = TweenAnimationBuilder<double>(
        key: ValueKey('shake_${index}_$shakeCount'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        onEnd: () {
          if (mounted && shakingIndex == index) {
            setState(() => shakingIndex = null);
          }
        },
        builder: (context, t, child) {
          final dx = sin(t * pi * 4) * 8 * (1 - t);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: tile,
      );
    }

    // RepaintBoundaryでタイルごとに再描画を分離する
    // （1枚のアニメーション中に盤面全体を描き直さない）
    return RepaintBoundary(
      child: ScaleTransition(scale: _entranceAnimations[index], child: tile),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    _elapsedMs.dispose();
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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '次: ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      AnimatedSwitcher(
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
                          '${min(currentNumber, widget.gameMode.maxNumber)}',
                          key: ValueKey(currentNumber),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 33msごとの時刻更新はこのTextだけを再ビルドする
                  ValueListenableBuilder<int>(
                    valueListenable: _elapsedMs,
                    builder: (context, elapsed, _) => Text(
                      'タイム: ${formatTimeMs(elapsed)}',
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
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
        ],
      ),
    );
  }
}

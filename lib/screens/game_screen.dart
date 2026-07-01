import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/game_mode.dart';
import '../models/achievement.dart';
import '../services/audio_service.dart';
import '../services/ranking_service.dart';
import '../services/settings_service.dart';
import '../services/statistics_service.dart';
import '../services/achievement_service.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;

  const GameScreen({super.key, required this.gameMode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> numbers;
  late List<bool> tapped;
  int currentNumber = 1;
  int elapsedMilliseconds = 0;
  Timer? timer;
  bool isPlaying = false;
  late AudioService audioService;
  late RankingService rankingService;
  late StatisticsService statisticsService;
  late AchievementService achievementService;
  Set<int> animatingNumbers = {};
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initServices();
    _initGame();
  }

  Future<void> _initServices() async {
    final settingsService = SettingsService();
    await settingsService.init();
    audioService = AudioService(settingsService);

    rankingService = RankingService();
    await rankingService.init();

    statisticsService = StatisticsService();
    await statisticsService.init();

    achievementService = AchievementService();
    await achievementService.init();
  }

  void _initGame() {
    numbers = List.generate(widget.gameMode.maxNumber, (index) => index + 1);
    numbers.shuffle(Random());
    tapped = List.generate(widget.gameMode.maxNumber, (index) => false);
    currentNumber = 1;
    elapsedMilliseconds = 0;
    isPlaying = false;
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        elapsedMilliseconds += 10;
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
  }

  void _onNumberTap(int index) async {
    if (!isPlaying) {
      isPlaying = true;
      _startTimer();
    }

    final tappedNumber = numbers[index];

    if (tappedNumber == currentNumber) {
      setState(() {
        tapped[index] = true;
        animatingNumbers.add(index);
      });

      await audioService.playCorrectSound();

      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        animatingNumbers.remove(index);
      });

      currentNumber++;

      if (currentNumber > widget.gameMode.maxNumber) {
        _stopTimer();
        _confettiController.play();
        await audioService.playCompleteSound();
        await rankingService.addRanking(widget.gameMode, elapsedMilliseconds);
        await statisticsService.recordGame(widget.gameMode, elapsedMilliseconds);

        final stats = await statisticsService.getStatistics();
        final newAchievements = await achievementService.checkAchievements(
          stats,
          widget.gameMode,
          elapsedMilliseconds,
        );

        _showCompleteDialog(newAchievements);
      }
    } else {
      await audioService.playErrorSound();
    }
  }

  void _showCompleteDialog(List<AchievementType> newAchievements) {
    final seconds = elapsedMilliseconds ~/ 1000;
    final milliseconds = elapsedMilliseconds % 1000;
    final timeString = '$seconds.${milliseconds.toString().padLeft(3, '0')}s';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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

  String _formatTime() {
    final seconds = elapsedMilliseconds ~/ 1000;
    final milliseconds = elapsedMilliseconds % 1000;
    return '$seconds.${milliseconds.toString().padLeft(3, '0')}';
  }

  @override
  void dispose() {
    _stopTimer();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameMode.displayName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '次: $currentNumber',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'タイム: ${_formatTime()}s',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 利用可能なスペースを計算
                final availableWidth = constraints.maxWidth - 32;
                final availableHeight = constraints.maxHeight - 32;

                // グリッドサイズに基づいて各セルのサイズを計算
                final cellSize = (availableWidth / widget.gameMode.gridSize).clamp(
                  60.0,
                  (availableHeight / widget.gameMode.gridSize).clamp(60.0, 120.0),
                );

                // フォントサイズを動的に計算
                final fontSize = (cellSize * 0.4).clamp(20.0, 48.0);

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
                        itemBuilder: (context, index) {
                          final number = numbers[index];
                          final isTapped = tapped[index];
                          final isAnimating = animatingNumbers.contains(index);

                          return AnimatedScale(
                            scale: isAnimating ? 1.2 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: Material(
                              color: isTapped
                                  ? Colors.grey[300]
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: isTapped ? null : () => _onNumberTap(index),
                                borderRadius: BorderRadius.circular(8),
                                child: Center(
                                  child: Text(
                                    isTapped ? '' : number.toString(),
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: isTapped ? Colors.transparent : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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

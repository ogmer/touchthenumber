import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  // セキュリティ設定
  _initializeSecurity();
  runApp(const TouchTheNumberApp());
}

void _initializeSecurity() {
  // デバッグモードでの実行を制限
  if (kDebugMode) {
    print('Warning: Running in debug mode');
  }

  // エラーハンドリングの設定
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _logSecurityEvent('Flutter Error: ${details.exception}');
  };

  // プラットフォームエラーハンドリング
  PlatformDispatcher.instance.onError = (error, stack) {
    _logSecurityEvent('Platform Error: $error');
    return true;
  };
}

void _logSecurityEvent(String message) {
  // セキュリティイベントのログ出力
  final timestamp = DateTime.now().toIso8601String();
  // セキュリティログ出力
  debugPrint('[$timestamp] SECURITY: $message');
}

enum GameMode { fiveByFive, sixBySix, sevenBySeven }

class GameRecord {
  final int timeInMilliseconds;
  final DateTime dateTime;
  final String displayTime;
  final GameMode gameMode;

  GameRecord({
    required this.timeInMilliseconds,
    required this.dateTime,
    required this.displayTime,
    required this.gameMode,
  }) {
    // 入力値の検証
    _validateInput();
  }

  void _validateInput() {
    if (timeInMilliseconds < 0 || timeInMilliseconds > 3600000) {
      // 1時間制限
      throw ArgumentError('Invalid time: $timeInMilliseconds');
    }
    if (displayTime.isEmpty || displayTime.length > 20) {
      throw ArgumentError('Invalid display time: $displayTime');
    }
    if (!GameMode.values.contains(gameMode)) {
      throw ArgumentError('Invalid game mode: $gameMode');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'timeInMilliseconds': timeInMilliseconds,
        'dateTime': dateTime.toIso8601String(),
        'displayTime': _sanitizeString(displayTime),
        'gameMode': gameMode.name,
      };
    } catch (e) {
      _logSecurityEvent('JSON serialization error: $e');
      rethrow;
    }
  }

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    try {
      // 入力データの検証
      if (json['timeInMilliseconds'] == null ||
          json['dateTime'] == null ||
          json['displayTime'] == null ||
          json['gameMode'] == null) {
        throw ArgumentError('Missing required fields in JSON');
      }

      final timeInMs = json['timeInMilliseconds'] as int;
      final dateTimeStr = json['dateTime'] as String;
      final displayTimeStr = json['displayTime'] as String;
      final gameModeStr = json['gameMode'] as String;

      // 値の範囲チェック
      if (timeInMs < 0 || timeInMs > 3600000) {
        throw ArgumentError('Invalid time value: $timeInMs');
      }

      return GameRecord(
        timeInMilliseconds: timeInMs,
        dateTime: DateTime.parse(dateTimeStr),
        displayTime: _sanitizeString(displayTimeStr),
        gameMode: GameMode.values.firstWhere(
          (mode) => mode.name == gameModeStr,
          orElse: () => GameMode.fiveByFive,
        ),
      );
    } catch (e) {
      _logSecurityEvent('JSON deserialization error: $e');
      rethrow;
    }
  }

  static String _sanitizeString(String input) {
    // 危険な文字を除去
    String result = input;
    result = result.replaceAll('<', '');
    result = result.replaceAll('>', '');
    result = result.replaceAll('"', '');
    result = result.replaceAll("'", '');
    result = result.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    return result.trim();
  }
}

class TouchTheNumberApp extends StatelessWidget {
  const TouchTheNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch The Number',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenu(),
      // パフォーマンス最適化
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // テキストスケーリングを無効化
          ),
          child: child!,
        );
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touch The Number'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.touch_app, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Touch The Number',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('数字を順番にタップしよう！', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 40),
            _GameModeButton(
              title: '5×5モード',
              gameMode: GameMode.fiveByFive,
              icon: Icons.grid_4x4,
            ),
            const SizedBox(height: 16),
            _GameModeButton(
              title: '6×6モード',
              gameMode: GameMode.sixBySix,
              icon: Icons.grid_3x3,
            ),
            const SizedBox(height: 16),
            _GameModeButton(
              title: '7×7モード',
              gameMode: GameMode.sevenBySeven,
              icon: Icons.grid_on,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RankingScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.leaderboard),
              label: const Text('ランキング'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// パフォーマンス最適化: ゲームモードボタンを分離
class _GameModeButton extends StatelessWidget {
  final String title;
  final GameMode gameMode;
  final IconData icon;

  const _GameModeButton({
    required this.title,
    required this.gameMode,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TouchTheNumberGame(gameMode: gameMode),
          ),
        );
      },
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class TouchTheNumberGame extends StatefulWidget {
  final GameMode gameMode;

  const TouchTheNumberGame({super.key, required this.gameMode});

  @override
  State<TouchTheNumberGame> createState() => _TouchTheNumberGameState();
}

class _TouchTheNumberGameState extends State<TouchTheNumberGame>
    with TickerProviderStateMixin {
  List<int> numbers = [];
  int currentNumber = 1;
  int score = 0;
  bool isGameStarted = false;
  bool isGameCompleted = false;
  bool showStartButton = true;
  late Stopwatch stopwatch;
  Timer? gameTimer;
  String displayTime = '00:00';
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadSoundSettings();
    _initializeGame();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    gameTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    if (!GameMode.values.contains(widget.gameMode)) {
      _logSecurityEvent('Invalid game mode: ${widget.gameMode}');
      return;
    }

    final totalNumbers = switch (widget.gameMode) {
      GameMode.fiveByFive => 25,
      GameMode.sixBySix => 36,
      GameMode.sevenBySeven => 49,
    };

    if (totalNumbers < 1 || totalNumbers > 100) {
      _logSecurityEvent('Invalid total numbers: $totalNumbers');
      return;
    }

    // パフォーマンス最適化: 既存のリストを再利用
    if (numbers.length != totalNumbers) {
      numbers = List.generate(totalNumbers, (index) => index + 1);
    } else {
      for (int i = 0; i < totalNumbers; i++) {
        numbers[i] = i + 1;
      }
    }

    numbers.shuffle(Random());
    currentNumber = 1;
    score = 0;
    isGameStarted = false;
    isGameCompleted = false;
    showStartButton = true;
    displayTime = '00:00';

    _logSecurityEvent('Game initialized for mode: ${widget.gameMode.name}');
  }

  void _startGame() {
    if (isGameStarted || isGameCompleted) {
      _logSecurityEvent(
        'Invalid game state for start: started=$isGameStarted, completed=$isGameCompleted',
      );
      return;
    }

    setState(() {
      isGameStarted = true;
      showStartButton = false;
      stopwatch.reset();
      stopwatch.start();
    });

    _playSound('start');
    _pulseController.repeat(reverse: true);
    _updateTimer();

    _logSecurityEvent('Game started for mode: ${widget.gameMode.name}');
  }

  void _updateTimer() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && isGameStarted && !isGameCompleted) {
        final elapsed = stopwatch.elapsedMilliseconds;
        final minutes = (elapsed ~/ 60000).toString().padLeft(2, '0');
        final seconds = ((elapsed % 60000) ~/ 1000).toString().padLeft(2, '0');
        final milliseconds = ((elapsed % 1000) ~/ 10).toString().padLeft(
          2,
          '0',
        );
        final newDisplayTime = '$minutes:$seconds.$milliseconds';

        // パフォーマンス最適化: 値が変更された場合のみsetStateを呼び出し
        if (displayTime != newDisplayTime) {
          setState(() {
            displayTime = newDisplayTime;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _handleNumberTap(int number) {
    if (number < 1 || number > 100) {
      _logSecurityEvent('Invalid number tapped: $number');
      return;
    }

    if (!isGameStarted) return;

    if (number == currentNumber) {
      _playSound('correct');
      _bounceController.forward().then((_) => _bounceController.reverse());

      setState(() {
        score++;
        currentNumber++;
      });

      final maxNumber = switch (widget.gameMode) {
        GameMode.fiveByFive => 25,
        GameMode.sixBySix => 36,
        GameMode.sevenBySeven => 49,
      };
      if (currentNumber > maxNumber) {
        _completeGame();
      }
    } else {
      _playSound('wrong');
    }
  }

  void _completeGame() {
    if (!isGameStarted || isGameCompleted) {
      _logSecurityEvent(
        'Invalid game state for completion: started=$isGameStarted, completed=$isGameCompleted',
      );
      return;
    }

    setState(() {
      isGameCompleted = true;
      stopwatch.stop();
      gameTimer?.cancel();
    });

    _playSound('complete');
    _pulseController.stop();
    _saveGameRecord();

    _logSecurityEvent(
      'Game completed for mode: ${widget.gameMode.name}, time: ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  Future<void> _saveGameRecord() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // データの検証
      if (stopwatch.elapsedMilliseconds < 0 ||
          stopwatch.elapsedMilliseconds > 3600000) {
        _logSecurityEvent(
          'Invalid game time: ${stopwatch.elapsedMilliseconds}',
        );
        return;
      }

      final record = GameRecord(
        timeInMilliseconds: stopwatch.elapsedMilliseconds,
        dateTime: DateTime.now(),
        displayTime: displayTime,
        gameMode: widget.gameMode,
      );

      final recordsJson = prefs.getStringList('game_records') ?? [];
      final records = <GameRecord>[];

      // 既存データの安全な読み込み
      for (final json in recordsJson) {
        try {
          final record = GameRecord.fromJson(jsonDecode(json));
          records.add(record);
        } catch (e) {
          _logSecurityEvent('Corrupted record found, skipping: $e');
          continue;
        }
      }

      records.add(record);
      records.sort(
        (a, b) => a.timeInMilliseconds.compareTo(b.timeInMilliseconds),
      );

      // 上位10件のみ保存（データサイズ制限）
      if (records.length > 10) {
        records.removeRange(10, records.length);
      }

      final updatedRecordsJson = records
          .map((record) => jsonEncode(record.toJson()))
          .toList();

      // データサイズの制限チェック
      final totalSize = updatedRecordsJson.join().length;
      if (totalSize > 10000) {
        // 10KB制限
        _logSecurityEvent('Data size limit exceeded: $totalSize bytes');
        return;
      }

      await prefs.setStringList('game_records', updatedRecordsJson);
      _logSecurityEvent('Game record saved successfully');
    } catch (e) {
      _logSecurityEvent('Failed to save game record: $e');
      // エラーが発生してもアプリは継続動作
    }
  }

  void _restartGame() {
    if (!isGameCompleted && !isGameStarted) {
      _logSecurityEvent(
        'Invalid game state for restart: started=$isGameStarted, completed=$isGameCompleted',
      );
      return;
    }

    setState(() {
      _initializeGame();
    });
    _pulseController.stop();

    _logSecurityEvent('Game restarted for mode: ${widget.gameMode.name}');
  }

  Future<void> _loadSoundSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final soundSetting = prefs.getBool('sound_enabled');

    if (soundSetting != null) {
      setState(() {
        _soundEnabled = soundSetting;
      });
    } else {
      setState(() {
        _soundEnabled = true;
      });
      await prefs.setBool('sound_enabled', true);
    }
  }

  Future<void> _playSound(String soundType) async {
    if (!_soundEnabled) return;

    // デバッグモードでは音声を再生しない
    if (kDebugMode) return;

    try {
      switch (soundType) {
        case 'correct':
          await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
          break;
        case 'wrong':
          await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
          break;
        case 'start':
          await _audioPlayer.play(AssetSource('sounds/start.mp3'));
          break;
        case 'complete':
          await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
          break;
      }
    } catch (e) {
      // 音声ファイルがない場合は無視
    }
  }

  void _toggleSound() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_soundEnabled;

    setState(() {
      _soundEnabled = newValue;
    });

    await prefs.setBool('sound_enabled', newValue);
    _logSecurityEvent('Sound setting changed to: $newValue');
  }

  // パフォーマンス最適化: 色をキャッシュ
  static const Color _completedColor = Color(0x4D4CAF50);
  static const Color _pendingColor = Color(0x4D9E9E9E);
  static const Color _errorColor = Color(0x4D9E9E9E);

  Color _getNumberColor(int number) {
    if (number < 1 || number > 100) {
      _logSecurityEvent('Invalid number for color: $number');
      return _errorColor;
    }

    if (number < currentNumber) {
      return _completedColor; // 完了した数字
    } else if (number == currentNumber) {
      return _pendingColor; // 現在の数字（通常表示）
    } else {
      return _pendingColor; // 未完了の数字
    }
  }

  // パフォーマンス最適化: グリッドデリゲートをキャッシュ
  SliverGridDelegateWithFixedCrossAxisCount _getGridDelegate() {
    return switch (widget.gameMode) {
      GameMode.fiveByFive => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      GameMode.sixBySix => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
      ),
      GameMode.sevenBySeven => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
    };
  }

  // パフォーマンス最適化: アイテム数をキャッシュ
  int _getItemCount() {
    return switch (widget.gameMode) {
      GameMode.fiveByFive => 25,
      GameMode.sixBySix => 36,
      GameMode.sevenBySeven => 49,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touch The Number'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleSound,
            icon: Icon(
              _soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: _soundEnabled ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // スコアとタイマー表示
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'スコア',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '$score/${widget.gameMode == GameMode.fiveByFive
                            ? 25
                            : widget.gameMode == GameMode.sixBySix
                            ? 36
                            : 49}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('時間', style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        displayTime,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // スタートボタン
            if (showStartButton)
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.blue,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '準備完了！',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'スタートボタンを押してゲームを開始してください',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _startGame,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('スタート'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            // ゲーム完了メッセージ
            if (isGameCompleted)
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'おめでとうございます！',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '完了時間: $displayTime',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

            // 数字グリッド
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: GridView.builder(
                    gridDelegate: _getGridDelegate(),
                    itemCount: _getItemCount(),
                    itemBuilder: (context, index) {
                      final number = numbers[index];
                      return _NumberTile(
                        number: number,
                        currentNumber: currentNumber,
                        isGameStarted: isGameStarted,
                        gameMode: widget.gameMode,
                        bounceAnimation: _bounceAnimation,
                        pulseAnimation: _pulseAnimation,
                        onTap: _handleNumberTap,
                        getNumberColor: _getNumberColor,
                      );
                    },
                  ),
                ),
              ),
            ),

            // ボタン群
            if (isGameCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _restartGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('もう一度'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainMenu(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('ホーム'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RankingScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.leaderboard),
                      label: const Text('ランキングを見る'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<GameRecord> records = [];
  GameMode selectedMode = GameMode.fiveByFive;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getStringList('game_records') ?? [];
      final loadedRecords = <GameRecord>[];

      // 安全なデータ読み込み
      for (final json in recordsJson) {
        try {
          final record = GameRecord.fromJson(jsonDecode(json));
          loadedRecords.add(record);
        } catch (e) {
          _logSecurityEvent('Corrupted record found, skipping: $e');
          continue;
        }
      }

      setState(() {
        records = loadedRecords;
        // キャッシュをクリア
        _cachedFilteredRecords = null;
        _lastSelectedMode = null;
      });
    } catch (e) {
      _logSecurityEvent('Failed to load records: $e');
      setState(() {
        records = [];
        _cachedFilteredRecords = null;
        _lastSelectedMode = null;
      });
    }
  }

  // パフォーマンス最適化: フィルタリング結果をキャッシュ
  List<GameRecord>? _cachedFilteredRecords;
  GameMode? _lastSelectedMode;

  List<GameRecord> _getFilteredRecords() {
    // モードが変更された場合のみ再計算
    if (_lastSelectedMode != selectedMode || _cachedFilteredRecords == null) {
      _cachedFilteredRecords = records
          .where((record) => record.gameMode == selectedMode)
          .toList();
      _lastSelectedMode = selectedMode;
    }
    return _cachedFilteredRecords!;
  }

  String _getModeDisplayName(GameMode mode) {
    return switch (mode) {
      GameMode.fiveByFive => '5×5モード',
      GameMode.sixBySix => '6×6モード',
      GameMode.sevenBySeven => '7×7モード',
    };
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords = _getFilteredRecords();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          if (filteredRecords.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      '${_getModeDisplayName(selectedMode)}のランキングをクリア',
                    ),
                    content: const Text('このモードの記録を削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearModeRecords();
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Column(
        children: [
          // モード選択タブ
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: GameMode.values.map((mode) {
                final isSelected = selectedMode == mode;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedMode = mode;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _getModeDisplayName(mode),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // ランキングリスト
          Expanded(
            child: filteredRecords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.leaderboard_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_getModeDisplayName(selectedMode)}の記録がありません',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ゲームをプレイして記録を作ろう！',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      final rank = index + 1;
                      final isTopThree = rank <= 3;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isTopThree
                                  ? (rank == 1
                                        ? Colors.amber
                                        : rank == 2
                                        ? Colors.grey[300]
                                        : Colors.orange[300])
                                  : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                rank.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            record.displayTime,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isTopThree ? Colors.amber[800] : null,
                                ),
                          ),
                          subtitle: Text(
                            '${record.dateTime.year}/${record.dateTime.month}/${record.dateTime.day} '
                            '${record.dateTime.hour.toString().padLeft(2, '0')}:'
                            '${record.dateTime.minute.toString().padLeft(2, '0')}',
                          ),
                          trailing: isTopThree
                              ? Icon(
                                  rank == 1
                                      ? Icons.emoji_events
                                      : rank == 2
                                      ? Icons.emoji_events
                                      : Icons.emoji_events,
                                  color: rank == 1
                                      ? Colors.amber
                                      : rank == 2
                                      ? Colors.grey[600]
                                      : Colors.orange[600],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearModeRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getStringList('game_records') ?? [];
      final allRecords = <GameRecord>[];

      // 安全なデータ読み込み
      for (final json in recordsJson) {
        try {
          final record = GameRecord.fromJson(jsonDecode(json));
          allRecords.add(record);
        } catch (e) {
          _logSecurityEvent('Corrupted record found, skipping: $e');
          continue;
        }
      }

      // 選択されたモード以外の記録を保持
      final filteredRecords = allRecords
          .where((record) => record.gameMode != selectedMode)
          .toList();

      final updatedRecordsJson = filteredRecords
          .map((record) => jsonEncode(record.toJson()))
          .toList();

      // データサイズの制限チェック
      final totalSize = updatedRecordsJson.join().length;
      if (totalSize > 10000) {
        // 10KB制限
        _logSecurityEvent('Data size limit exceeded: $totalSize bytes');
        return;
      }

      await prefs.setStringList('game_records', updatedRecordsJson);
      _logSecurityEvent('Mode records cleared for: ${selectedMode.name}');
      _loadRecords();
    } catch (e) {
      _logSecurityEvent('Failed to clear mode records: $e');
    }
  }
}

// パフォーマンス最適化: 数字タイルを分離
class _NumberTile extends StatelessWidget {
  final int number;
  final int currentNumber;
  final bool isGameStarted;
  final GameMode gameMode;
  final Animation<double> bounceAnimation;
  final Animation<double> pulseAnimation;
  final Function(int) onTap;
  final Color Function(int) getNumberColor;

  const _NumberTile({
    required this.number,
    required this.currentNumber,
    required this.isGameStarted,
    required this.gameMode,
    required this.bounceAnimation,
    required this.pulseAnimation,
    required this.onTap,
    required this.getNumberColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([bounceAnimation, pulseAnimation]),
      builder: (context, child) {
        double scale = 1.0;
        // 正解した数字のバウンスアニメーション
        if (number < currentNumber && isGameStarted) {
          scale = 1.0 + (bounceAnimation.value - 1.0) * 0.1; // 小さなバウンス効果
        }
        // 現在の数字（次に押すべき数字）のアニメーションを無効化
        // if (number == currentNumber && isGameStarted) {
        //   scale = bounceAnimation.value;
        // } else if (number == currentNumber && !isGameStarted) {
        //   scale = pulseAnimation.value;
        // }

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: isGameStarted ? () => onTap(number) : null,
            child: Container(
              decoration: BoxDecoration(
                color: getNumberColor(number),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(number.toString(), style: _getTextStyle(context)),
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final baseStyle = switch (gameMode) {
      GameMode.fiveByFive => Theme.of(context).textTheme.headlineSmall,
      GameMode.sixBySix => Theme.of(context).textTheme.titleLarge,
      GameMode.sevenBySeven => Theme.of(context).textTheme.titleMedium,
    };

    return baseStyle?.copyWith(
      fontWeight: FontWeight.bold,
      color: number < currentNumber ? Colors.green : Colors.grey,
    );
  }
}

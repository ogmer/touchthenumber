import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/models/achievement.dart';
import 'package:touchthenumber/models/game_mode.dart';
import 'package:touchthenumber/screens/game_screen.dart';
import 'package:touchthenumber/services/achievement_service.dart';
import 'package:touchthenumber/services/ranking_service.dart';
import 'package:touchthenumber/services/statistics_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StatisticsService', () {
    test('recordGame increments today games count', () async {
      SharedPreferences.setMockInitialValues({});
      final service = StatisticsService(await SharedPreferences.getInstance());

      expect(await service.getTodayGamesCount(), 0);

      await service.recordGame(GameMode.easy, 15000);
      await service.recordGame(GameMode.medium, 20000);

      expect(await service.getTodayGamesCount(), 2);
    });

    test('today games count resets on a different date', () async {
      SharedPreferences.setMockInitialValues({
        'daily_count': '{"date":"2000-01-01","count":9}',
      });
      final service = StatisticsService(await SharedPreferences.getInstance());

      expect(await service.getTodayGamesCount(), 0);
    });

    test('reset clears statistics and daily count', () async {
      SharedPreferences.setMockInitialValues({});
      final service = StatisticsService(await SharedPreferences.getInstance());

      await service.recordGame(GameMode.easy, 15000);
      await service.reset();

      expect(await service.getTodayGamesCount(), 0);
      final stats = await service.getStatistics();
      expect(stats.overallTotalGames, 0);
    });
  });

  group('calcCellSize (グリッドの見切れ防止)', () {
    test('grid fits within available area for all modes and sizes', () {
      const sizes = [
        (300.0, 400.0), // 小さいスマホ縦
        (500.0, 350.0), // 横長の狭いウィンドウ
        (568.0, 668.0), // デスクトップ最小ウィンドウ相当
        (1200.0, 900.0), // 大画面
      ];
      for (final mode in GameMode.values) {
        for (final (w, h) in sizes) {
          final cell = calcCellSize(
            availableWidth: w,
            availableHeight: h,
            gridSize: mode.gridSize,
          );
          final gridExtent = cell * mode.gridSize + 8.0 * (mode.gridSize - 1);
          // セルが極小になる下限クランプ時を除き、グリッドは領域内に収まる
          if (cell > 28.0) {
            expect(gridExtent, lessThanOrEqualTo(w),
                reason: '${mode.displayName} @ ${w}x$h width');
            expect(gridExtent, lessThanOrEqualTo(h),
                reason: '${mode.displayName} @ ${w}x$h height');
          }
          expect(cell, lessThanOrEqualTo(120.0));
        }
      }
    });

    test('7x7 fits in the 600x700 minimum desktop window', () {
      // window_setup_desktop.dart の最小ウィンドウ(600x700)から
      // AppBar・ヘッダー・パディングを引いた領域に7x7が収まること
      final cell = calcCellSize(
        availableWidth: 600 - 32,
        availableHeight: 700 - 56 - 60 - 32,
        gridSize: 7,
      );
      final gridExtent = cell * 7 + 8.0 * 6;
      expect(gridExtent, lessThanOrEqualTo(600 - 32));
      expect(gridExtent, lessThanOrEqualTo(700 - 56 - 60 - 32));
    });
  });

  group('RankingService (改ざん・破損データ耐性)', () {
    test('corrupted ranking JSON is treated as empty', () async {
      SharedPreferences.setMockInitialValues({
        'ranking_easy': 'not a json {{{',
      });
      final service = RankingService(await SharedPreferences.getInstance());

      expect(await service.getRankings(GameMode.easy), isEmpty);
      // 壊れたデータがあっても新しい記録は保存できる
      await service.addRanking(GameMode.easy, 12345);
      final rankings = await service.getRankings(GameMode.easy);
      expect(rankings.length, 1);
      expect(rankings.first.timeInMilliseconds, 12345);
    });

    test('invalid entries are filtered out', () async {
      SharedPreferences.setMockInitialValues({
        'ranking_easy': '['
            '{"timeInMilliseconds":-5,"date":"2026-01-01T00:00:00.000"},'
            '{"timeInMilliseconds":"cheat","date":"2026-01-01T00:00:00.000"},'
            '{"timeInMilliseconds":9000,"date":"2026-01-01T00:00:00.000"},'
            '{"broken":true}'
            ']',
      });
      final service = RankingService(await SharedPreferences.getInstance());

      final rankings = await service.getRankings(GameMode.easy);
      expect(rankings.length, 1);
      expect(rankings.first.timeInMilliseconds, 9000);
    });
  });

  group('Statistics (改ざん・破損データ耐性)', () {
    test('negative or non-int values are read as zero', () async {
      SharedPreferences.setMockInitialValues({
        'statistics': '{'
            '"totalGames":{"easy":-3,"medium":"x","hard":2},'
            '"totalTime":{"easy":-1,"medium":0,"hard":60000},'
            '"bestTime":{"easy":0,"medium":0,"hard":30000}'
            '}',
      });
      final service = StatisticsService(await SharedPreferences.getInstance());

      final stats = await service.getStatistics();
      expect(stats.totalGames[GameMode.easy], 0);
      expect(stats.totalGames[GameMode.medium], 0);
      expect(stats.totalGames[GameMode.hard], 2);
      expect(stats.bestTime[GameMode.hard], 30000);
    });

    test('tampered daily count is read as zero', () async {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      SharedPreferences.setMockInitialValues({
        'daily_count': '{"date":"$dateStr","count":-99}',
      });
      final service = StatisticsService(await SharedPreferences.getInstance());

      expect(await service.getTodayGamesCount(), 0);
    });
  });

  group('AchievementService', () {
    test('perfectDay unlocks after 10 games in one day', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final statsService = StatisticsService(prefs);
      final achievementService = AchievementService(prefs);

      for (var i = 0; i < 10; i++) {
        await statsService.recordGame(GameMode.easy, 30000);
      }

      final stats = await statsService.getStatistics();
      final todayCount = await statsService.getTodayGamesCount();
      final unlocked = await achievementService.checkAchievements(
        stats,
        GameMode.easy,
        30000,
        todayCount,
      );

      expect(unlocked, contains(AchievementType.perfectDay));
    });

    test('perfectDay stays locked below 10 games', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final statsService = StatisticsService(prefs);
      final achievementService = AchievementService(prefs);

      await statsService.recordGame(GameMode.easy, 30000);

      final stats = await statsService.getStatistics();
      final todayCount = await statsService.getTodayGamesCount();
      final unlocked = await achievementService.checkAchievements(
        stats,
        GameMode.easy,
        30000,
        todayCount,
      );

      expect(unlocked, isNot(contains(AchievementType.perfectDay)));
    });
  });
}

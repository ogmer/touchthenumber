import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/game_mode.dart';
import 'screens/achievements_screen.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ranking_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/tutorial_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'game/:mode',
            builder: (context, state) {
              // 不正なパラメータはeasyにフォールバックする
              final mode =
                  GameMode.values.asNameMap()[state.pathParameters['mode']] ??
                      GameMode.easy;
              return GameScreen(gameMode: mode);
            },
          ),
          GoRoute(
            path: 'ranking',
            builder: (context, state) => const RankingScreen(),
          ),
          GoRoute(
            path: 'statistics',
            builder: (context, state) => const StatisticsScreen(),
          ),
          GoRoute(
            path: 'achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'tutorial',
            builder: (context, state) => const TutorialScreen(),
          ),
        ],
      ),
    ],
  );
});

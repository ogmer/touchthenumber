import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_theme.dart';
import 'services/achievement_service.dart';
import 'services/audio_service.dart';
import 'services/ranking_service.dart';
import 'services/settings_service.dart';
import 'services/statistics_service.dart';

/// main()で取得した SharedPreferences を注入する。
/// ProviderScope の overrides で必ず上書きされる前提
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('main()でoverrideすること'),
);

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref.watch(sharedPreferencesProvider)),
);

final rankingServiceProvider = Provider<RankingService>(
  (ref) => RankingService(ref.watch(sharedPreferencesProvider)),
);

final statisticsServiceProvider = Provider<StatisticsService>(
  (ref) => StatisticsService(ref.watch(sharedPreferencesProvider)),
);

final achievementServiceProvider = Provider<AchievementService>(
  (ref) => AchievementService(ref.watch(sharedPreferencesProvider)),
);

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService(ref.watch(settingsServiceProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// テーマ変更をアプリ全体に反映するための状態
final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() => ref.watch(settingsServiceProvider).theme;

  Future<void> setTheme(AppTheme theme) async {
    await ref.read(settingsServiceProvider).setTheme(theme);
    state = theme;
  }
}

/// HTTPクライアント。現状このアプリはオフライン完結だが、
/// オンラインランキング等のAPI連携を追加するときはここを起点にする。
/// 注意: Android実機で通信する際は AndroidManifest.xml に
/// INTERNET パーミッションの追加が必要
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // baseUrl: 'https://api.example.com', // API導入時に設定する
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
  ref.onDispose(dio.close);
  return dio;
});

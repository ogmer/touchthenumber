import 'dart:ui' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_theme.dart';
import 'services/achievement_service.dart';
import 'services/audio_service.dart';
import 'services/ranking_service.dart';
import 'services/review_service.dart';
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

final reviewServiceProvider = Provider<ReviewService>(
  (ref) => ReviewService(ref.watch(sharedPreferencesProvider)),
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

/// 表示言語。nullはシステム設定に従う
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() =>
      localeFromCode(ref.watch(settingsServiceProvider).localeCode);

  Future<void> set(String? code) async {
    await ref.read(settingsServiceProvider).setLocaleCode(code);
    state = localeFromCode(code);
  }
}

/// 'ja' や 'zh_Hant'（スクリプトコード付き）の文字列をLocaleに変換する
Locale? localeFromCode(String? code) {
  if (code == null) return null;
  final parts = code.split('_');
  if (parts.length == 2) {
    return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
  }
  return Locale(parts[0]);
}

/// Localeを設定保存用の文字列コードに戻す（localeFromCodeの逆変換）
String? codeFromLocale(Locale? locale) {
  if (locale == null) return null;
  final script = locale.scriptCode;
  return script == null
      ? locale.languageCode
      : '${locale.languageCode}_$script';
}

/// 効果音のオン/オフ。AppBarのボタンと設定画面のスイッチで共有する
final soundEnabledProvider = NotifierProvider<SoundEnabledNotifier, bool>(
  SoundEnabledNotifier.new,
);

class SoundEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsServiceProvider).isSoundEnabled;

  Future<void> set(bool value) async {
    await ref.read(settingsServiceProvider).setSoundEnabled(value);
    state = value;
  }
}

/// BGMのオン/オフ。設定画面のスイッチとAppBarのボタンで共有する
final bgmEnabledProvider = NotifierProvider<BgmEnabledNotifier, bool>(
  BgmEnabledNotifier.new,
);

class BgmEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsServiceProvider).isBgmEnabled;

  Future<void> set(bool value) async {
    await ref.read(settingsServiceProvider).setBgmEnabled(value);
    state = value;
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';
// 条件付きインポート: Web版とデスクトップ版で異なる実装を使用
import 'window_setup_stub.dart'
    if (dart.library.io) 'window_setup_io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // プラットフォームに応じたウィンドウ設定
  await setupWindow();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    final colorScheme = appTheme.colorScheme;

    return MaterialApp.router(
      title: 'Touch the Number',
      // 多言語対応: 端末のシステム言語に追従し、設定画面から手動切替も可能
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        // 日本語グリフを持つ同梱フォントを全体の既定にする（Web版の文字化け対策）
        fontFamily: 'MPLUSRounded1c',
        // 丸ゴシックに合わせた、丸く柔らかいデザインで全画面を統一する
        scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'MPLUSRounded1c',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 3,
            shadowColor: colorScheme.primary.withValues(alpha: 0.35),
            textStyle: const TextStyle(
              fontFamily: 'MPLUSRounded1c',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

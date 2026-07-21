import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final audioService = ref.read(audioServiceProvider);
    switch (state) {
      case AppLifecycleState.resumed:
        audioService.resumeBgmFromBackground();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        audioService.pauseBgmForBackground();
        break;
    }
  }

  /// テーマのシード色から、ニューモフィズムの淡い面色を導出する。
  /// 全テーマで明度・彩度をそろえ、色相だけシード色に合わせて柔らかく色付けする。
  static Color _neumorphicBase(Color seed) {
    final hsl = HSLColor.fromColor(seed);
    return hsl.withSaturation(0.18).withLightness(0.91).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);
    final colorScheme = appTheme.colorScheme;
    final neumorphicBase = _neumorphicBase(appTheme.color);

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
        // ニューモフィズム: 背景・要素・ダイアログすべてを同じ淡い面色で統一し、
        // 影の陰影だけで立体感を出す
        scaffoldBackgroundColor: neumorphicBase,
        canvasColor: neumorphicBase,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          // 背景は常にライト配色のため、OSのダークモードに関わらず
          // ステータスバーのアイコンは常に濃色で固定し、背景に埋もれないようにする
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          titleTextStyle: TextStyle(
            fontFamily: 'MPLUSRounded1c',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: neumorphicBase,
          elevation: 0,
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

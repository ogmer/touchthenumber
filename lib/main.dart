import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers.dart';
import 'router.dart';
// 条件付きインポート: Web版とデスクトップ版で異なる実装を使用
import 'window_setup_stub.dart'
    if (dart.library.io) 'window_setup_desktop.dart';

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
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Touch the Number',
      theme: ThemeData(
        colorScheme: theme.colorScheme,
        useMaterial3: true,
        // 日本語グリフを持つ同梱フォントを全体の既定にする（Web版の文字化け対策）
        fontFamily: 'MPLUSRounded1c',
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

import 'package:flutter/material.dart';
import 'services/settings_service.dart';
import 'screens/home_screen.dart';
// 条件付きインポート: Web版とデスクトップ版で異なる実装を使用
import 'window_setup_stub.dart'
    if (dart.library.io) 'window_setup_desktop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // プラットフォームに応じたウィンドウ設定
  await setupWindow();

  final settingsService = SettingsService();
  await settingsService.init();

  runApp(MyApp(settingsService: settingsService));
}

class MyApp extends StatefulWidget {
  final SettingsService settingsService;

  const MyApp({super.key, required this.settingsService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch the Number',
      theme: ThemeData(
        colorScheme: widget.settingsService.theme.colorScheme,
        useMaterial3: true,
      ),
      home: HomeScreen(
        settingsService: widget.settingsService,
        onThemeChanged: () => setState(() {}),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

// デスクトップ版用のウィンドウ設定
Future<void> setupWindow() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(900, 800),
    minimumSize: Size(600, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Touch the Number',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

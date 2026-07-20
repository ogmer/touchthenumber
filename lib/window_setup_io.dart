import 'dart:io' show Platform;

import 'window_setup_desktop.dart' as desktop;
import 'window_setup_stub.dart' as stub;

Future<void> setupWindow() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await desktop.setupWindow();
    return;
  }
  await stub.setupWindow();
}

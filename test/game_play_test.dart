import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/main.dart';
import 'package:touchthenumber/providers.dart';
import 'package:touchthenumber/services/audio_service.dart';

/// 音声プラグイン(MethodChannel)はテスト環境に無いため、何もしない代替に差し替える
class _NoopAudioService implements AudioService {
  // bool を返すゲッターは noSuchMethod では代用できないため明示的に実装する
  @override
  bool get isBgmPlaying => false;
  @override
  dynamic noSuchMethod(Invocation invocation) async {}
}

Finder _gridNumber(String n) => find.descendant(
      of: find.byType(GridView),
      matching: find.text(n),
    );

void main() {
  testWidgets('タイルを1から順にタップするとクリアできる（局所更新リファクタの検証）',
      (tester) async {
    // 5×5のグリッドが全部見えるよう画面を十分な大きさにする
    tester.view.physicalSize = const Size(600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioServiceProvider.overrideWithValue(_NoopAudioService()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 5×5モードで開始
    await tester.tap(find.text('5×5'));
    await tester.pumpAndSettle();

    // カウントダウン（準備OK？→3→2→1→スタート、約3.3秒）を消化
    await tester.pump(const Duration(milliseconds: 3400));
    // 登場アニメーション（約800ms）の完了を待つ
    await tester.pump(const Duration(milliseconds: 900));

    // 誤タップ: 「2」を先に押しても進まない（「1」がまだ盤面に残っている）
    await tester.tap(_gridNumber('2'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(_gridNumber('1'), findsOneWidget);

    // 1..25 を順にタップ
    for (var n = 1; n <= 25; n++) {
      await tester.tap(_gridNumber('$n'));
      await tester.pump(const Duration(milliseconds: 60));
    }

    // クリアダイアログが出る
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byType(AlertDialog), findsOneWidget);

    // 後始末: ダイアログを閉じて残りのタイマー/アニメーションを消化
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}

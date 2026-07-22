import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/main.dart';
import 'package:touchthenumber/providers.dart';
import 'package:touchthenumber/services/audio_service.dart';

/// 呼び出しを記録するだけのAudioServiceの代替。
/// privateメンバは別ライブラリからは公開APIに含まれないため implements で足りる
class SpyAudioService implements AudioService {
  final List<String> calls = [];

  @override
  Future<void> startGameBgm() async => calls.add('startGameBgm');
  @override
  Future<void> startTitleBgm() async => calls.add('startTitleBgm');
  @override
  Future<void> resumeBgm() async => calls.add('resumeBgm');
  @override
  Future<void> stopBgm() async => calls.add('stopBgm');
  @override
  Future<void> pauseBgmForBackground() async => calls.add('pauseBgmForBackground');
  @override
  Future<void> resumeBgmFromBackground() async => calls.add('resumeBgmFromBackground');
  @override
  Future<void> updateBgmVolume(double volume) async => calls.add('updateBgmVolume');
  @override
  bool get isBgmPlaying => false;
  @override
  Future<void> playCorrectSound() async {}
  @override
  Future<void> playErrorSound() async {}
  @override
  Future<void> playCompleteSound() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  testWidgets('game BGM starts automatically once the countdown finishes',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final spy = SpyAudioService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioServiceProvider.overrideWithValue(spy),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // ゲーム開始（5×5モード）
    await tester.tap(find.text('5×5'));
    await tester.pumpAndSettle();

    // カウントダウン中（準備OK？→3→2→1→スタート）はまだBGMが始まらない
    expect(spy.calls, isNot(contains('startGameBgm')));

    // 「準備OK？3・2・1・スタート」のカウントダウンが終わるまで進める
    // （ready/3/2/1/goで合計3300ms）。カウントダウン完了と同時にBGMが始まる
    await tester.pump(const Duration(milliseconds: 3400));

    expect(spy.calls, contains('startGameBgm'));

    // カウントダウン終了後はタイルをタップできる
    final firstTile = find.descendant(
      of: find.byType(GridView),
      matching: find.text('1'),
    );
    expect(firstTile, findsOneWidget);
    await tester.tap(firstTile);
    await tester.pump();

    // 後始末: ゲーム画面をdisposeしてタイマーを止め、残った遅延Timerを消化する
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 400));
  });
}

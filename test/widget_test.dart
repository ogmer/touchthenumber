import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/main.dart';
import 'package:touchthenumber/providers.dart';

Future<ProviderContainer> _pumpApp(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
  return container;
}

void main() {
  testWidgets('App launches with home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pumpApp(tester);

    expect(find.text('Touch the Number'), findsOneWidget);
    expect(find.text('ゲームモードを選択'), findsOneWidget);
  });

  testWidgets('Master mute button toggles both sound and BGM', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = await _pumpApp(tester);

    // 初期状態は両方オン（volume_upアイコン）
    expect(container.read(soundEnabledProvider), isTrue);
    expect(container.read(bgmEnabledProvider), isTrue);
    expect(find.byIcon(Icons.volume_up), findsOneWidget);

    // タップで効果音・BGMがまとめてオフになり、アイコンも切り替わる
    await tester.tap(find.byIcon(Icons.volume_up));
    await tester.pump();
    expect(container.read(soundEnabledProvider), isFalse);
    expect(container.read(bgmEnabledProvider), isFalse);
    expect(find.byIcon(Icons.volume_off), findsOneWidget);

    // もう一度タップで両方オンに戻る
    await tester.tap(find.byIcon(Icons.volume_off));
    await tester.pump();
    expect(container.read(soundEnabledProvider), isTrue);
    expect(container.read(bgmEnabledProvider), isTrue);
    expect(find.byIcon(Icons.volume_up), findsOneWidget);
  });
}

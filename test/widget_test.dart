// This is a basic Flutter widget test for Touch The Number app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Touch The Number app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Verify that the main menu is displayed.
    expect(find.text('Touch The Number'), findsWidgets);
    expect(find.text('数字を順番にタップしよう！'), findsOneWidget);
    expect(find.text('5×5モード'), findsOneWidget);
    expect(find.text('6×6モード'), findsOneWidget);
    expect(find.text('7×7モード'), findsOneWidget);
    expect(find.text('ランキング'), findsOneWidget);
  });

  testWidgets('5x5 game mode navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Tap the 5x5 mode button.
    await tester.tap(find.text('5×5モード'));
    await tester.pumpAndSettle();

    // Verify that the game screen is displayed.
    expect(find.text('Touch The Number'), findsWidgets);
    expect(find.text('スコア'), findsOneWidget);
    expect(find.text('時間'), findsOneWidget);
    expect(find.text('0/25'), findsOneWidget);
    expect(find.text('準備完了！'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
  });

  testWidgets('6x6 game mode navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Tap the 6x6 mode button.
    await tester.tap(find.text('6×6モード'));
    await tester.pumpAndSettle();

    // Verify that the game screen is displayed.
    expect(find.text('Touch The Number'), findsWidgets);
    expect(find.text('スコア'), findsOneWidget);
    expect(find.text('時間'), findsOneWidget);
    expect(find.text('0/36'), findsOneWidget);
    expect(find.text('準備完了！'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
  });

  testWidgets('7x7 game mode navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Tap the 7x7 mode button.
    await tester.tap(find.text('7×7モード'));
    await tester.pumpAndSettle();

    // Verify that the game screen is displayed.
    expect(find.text('Touch The Number'), findsWidgets);
    expect(find.text('スコア'), findsOneWidget);
    expect(find.text('時間'), findsOneWidget);
    expect(find.text('0/49'), findsOneWidget);
    expect(find.text('準備完了！'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
  });

  testWidgets('Ranking screen navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Tap the ranking button.
    await tester.tap(find.text('ランキング'));
    await tester.pumpAndSettle();

    // Verify that the ranking screen is displayed.
    expect(find.text('ランキング'), findsOneWidget);
    expect(find.text('5×5モード'), findsOneWidget);
    expect(find.text('6×6モード'), findsOneWidget);
    expect(find.text('7×7モード'), findsOneWidget);
    expect(find.text('5×5モードの記録がありません'), findsOneWidget);
    expect(find.text('ゲームをプレイして記録を作ろう！'), findsOneWidget);
  });

  testWidgets('Start button functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Navigate to 5x5 game mode.
    await tester.tap(find.text('5×5モード'));
    await tester.pumpAndSettle();

    // Verify start button is visible.
    expect(find.text('準備完了！'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);

    // Tap the start button.
    await tester.tap(find.text('スタート'));
    await tester.pump();

    // Verify start button is hidden after starting.
    expect(find.text('準備完了！'), findsNothing);
    expect(find.text('スタート'), findsNothing);
  });

  testWidgets('Ranking mode selection test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouchTheNumberApp());

    // Navigate to ranking screen.
    await tester.tap(find.text('ランキング'));
    await tester.pumpAndSettle();

    // Verify mode selection buttons are displayed.
    expect(find.text('5×5モード'), findsOneWidget);
    expect(find.text('6×6モード'), findsOneWidget);
    expect(find.text('7×7モード'), findsOneWidget);

    // Tap 6x6 mode button.
    await tester.tap(find.text('6×6モード'));
    await tester.pumpAndSettle();

    // Verify 6x6 mode is selected and message is updated.
    expect(find.text('6×6モードの記録がありません'), findsOneWidget);

    // Tap 7x7 mode button.
    await tester.tap(find.text('7×7モード'));
    await tester.pumpAndSettle();

    // Verify 7x7 mode is selected and message is updated.
    expect(find.text('7×7モードの記録がありません'), findsOneWidget);
  });
}

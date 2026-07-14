import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/main.dart';
import 'package:touchthenumber/providers.dart';

void main() {
  testWidgets('App launches with home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MyApp(),
      ),
    );

    expect(find.text('Touch the Number'), findsOneWidget);
    expect(find.text('ゲームモードを選択'), findsOneWidget);
  });
}

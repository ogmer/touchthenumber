import 'package:flutter_test/flutter_test.dart';
import 'package:touchthenumber/main.dart';
import 'package:touchthenumber/services/settings_service.dart';

void main() {
  testWidgets('App launches with home screen', (WidgetTester tester) async {
    final settingsService = SettingsService();
    await settingsService.init();

    await tester.pumpWidget(MyApp(settingsService: settingsService));

    expect(find.text('Touch the Number'), findsOneWidget);
    expect(find.text('ゲームモードを選択'), findsOneWidget);
  });
}

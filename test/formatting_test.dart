import 'package:flutter_test/flutter_test.dart';
import 'package:touchthenumber/utils/formatting.dart';

void main() {
  test('formatTimeMs pads milliseconds to 3 digits', () {
    expect(formatTimeMs(12345), '12.345s');
    expect(formatTimeMs(5008), '5.008s');
    expect(formatTimeMs(0), '0.000s');
  });

  test('formatDate and formatDateTime pad with zeros', () {
    final date = DateTime(2026, 7, 5, 9, 3);
    expect(formatDate(date), '2026/07/05');
    expect(formatDateTime(date), '2026/07/05 09:03');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:touchthenumber/models/game_mode.dart';
import 'package:touchthenumber/models/ranking_entry.dart';
import 'package:touchthenumber/utils/share_text.dart';

void main() {
  test('share text contains mode, time, rank, and hashtag', () {
    final entry = RankingEntry(
      timeInMilliseconds: 12345,
      date: DateTime(2026, 7, 15),
    );

    final text = buildRecordShareText(
      mode: GameMode.hard,
      rank: 3,
      entry: entry,
    );

    expect(text, contains('7×7'));
    expect(text, contains('12.345s'));
    expect(text, contains('3位'));
    expect(text, contains('#TouchTheNumber'));
  });
}

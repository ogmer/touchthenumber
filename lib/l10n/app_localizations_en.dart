// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Select Game Mode';

  @override
  String get difficultyEasy => 'Beginner';

  @override
  String get difficultyMedium => 'Intermediate';

  @override
  String get difficultyHard => 'Advanced';

  @override
  String get countdownReady => 'Ready?';

  @override
  String get countdownGo => 'Go!';

  @override
  String get newBestRecord => 'New Best!';

  @override
  String behindBest(String time) {
    return '$time off your best';
  }

  @override
  String rankLabel(int rank) {
    return 'Rank #$rank';
  }

  @override
  String get rankingLocalTab => 'Local';

  @override
  String get rankingOnlineTab => 'Online';

  @override
  String get nickname => 'Nickname';

  @override
  String get onlineUnavailable => 'Online ranking is unavailable';

  @override
  String get ranking => 'Ranking';

  @override
  String get statistics => 'Statistics';

  @override
  String get achievements => 'Achievements';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get settings => 'Settings';

  @override
  String get nextLabel => 'Next: ';

  @override
  String timeLabel(String time) {
    return 'Time: $time';
  }

  @override
  String get clearTitle => 'Clear!';

  @override
  String get newAchievements => '🏆 New Achievements!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noRecordsYet => 'No records yet';

  @override
  String resetRankingTitle(String mode) {
    return 'Reset $mode Ranking';
  }

  @override
  String get resetRankingMessage =>
      'Reset all rankings for this mode?\nThis cannot be undone.';

  @override
  String get shareRecord => 'Share record';

  @override
  String get copiedToClipboard => 'Record copied to clipboard';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] I scored $time in $mode mode! (Rank #$rank)\nTap the numbers from 1 in order in this brain-training time attack. Give it a try!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get overallStats => 'Overall Stats';

  @override
  String get totalPlays => 'Total Plays';

  @override
  String get totalPlayTime => 'Total Play Time';

  @override
  String get statsByDifficulty => 'Stats by Difficulty';

  @override
  String get playCount => 'Plays';

  @override
  String get bestTime => 'Best Time';

  @override
  String get averageTime => 'Average Time';

  @override
  String timesCount(int count) {
    return '$count times';
  }

  @override
  String get noData => 'No data';

  @override
  String get resetStatsTitle => 'Reset Statistics';

  @override
  String get resetStatsMessage =>
      'Reset all statistics?\nThis cannot be undone.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Unlocked: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Unlocked: $date';
  }

  @override
  String get achFirstWinTitle => 'First Victory';

  @override
  String get achFirstWinDesc => 'Clear the game for the first time';

  @override
  String get achSpeed10Title => 'Speed Star';

  @override
  String get achSpeed10Desc => 'Clear within 10 seconds';

  @override
  String get achSpeed20Title => 'Speed Master';

  @override
  String get achSpeed20Desc => 'Clear within 20 seconds';

  @override
  String get achGames10Title => 'Gamer';

  @override
  String get achGames10Desc => 'Play 10 times';

  @override
  String get achGames50Title => 'Veteran';

  @override
  String get achGames50Desc => 'Play 50 times';

  @override
  String get achGames100Title => 'Legend';

  @override
  String get achGames100Desc => 'Play 100 times';

  @override
  String get achAllModesTitle => 'All-Rounder';

  @override
  String get achAllModesDesc => 'Clear every mode';

  @override
  String get achPerfectDayTitle => 'Perfect Day';

  @override
  String get achPerfectDayDesc => 'Clear 10 times in one day';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themeGreen => 'Green';

  @override
  String get themePurple => 'Purple';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeRed => 'Red';

  @override
  String get themePink => 'Pink';

  @override
  String get themeTeal => 'Teal';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get sound => 'Sound';

  @override
  String get soundSubtitle => 'Sound effects and vibration';

  @override
  String get bgm => 'BGM';

  @override
  String get bgmSubtitle => 'Title and in-game music';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get tutGoalTitle => 'Goal';

  @override
  String get tutGoalDesc =>
      'Tap the numbers in order, starting from 1.\nTap them all in the correct order to clear the board!';

  @override
  String get tutTimeTitle => 'Race the Clock';

  @override
  String get tutTimeDesc =>
      'Aim to clear as fast as you can.\nYour time is recorded down to the millisecond.';

  @override
  String get tutRankingTitle => 'Ranking';

  @override
  String get tutRankingDesc =>
      'Your top 10 times are saved for each difficulty.\nKeep challenging your personal best!';

  @override
  String get tutAchievementsTitle => 'Achievements';

  @override
  String get tutAchievementsDesc =>
      'Complete specific goals to unlock achievements.\nCollect them all!';

  @override
  String get tutCustomizeTitle => 'Customize';

  @override
  String get tutCustomizeDesc =>
      'Change the theme color in Settings.\nPlay in your favorite color!';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get muteTooltip => 'Mute sounds';

  @override
  String get unmuteTooltip => 'Unmute sounds';
}

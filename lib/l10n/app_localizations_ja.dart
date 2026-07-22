// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'ゲームモードを選択';

  @override
  String get difficultyEasy => '初心者';

  @override
  String get difficultyMedium => '中級者';

  @override
  String get difficultyHard => '上級者';

  @override
  String get countdownReady => '準備OK？';

  @override
  String get countdownGo => 'スタート';

  @override
  String get newBestRecord => '自己ベスト更新！';

  @override
  String behindBest(String time) {
    return 'ベストまであと $time';
  }

  @override
  String rankLabel(int rank) {
    return '第$rank位';
  }

  @override
  String get almostFirst => 'もう少しで1位！';

  @override
  String get rankingLocalTab => 'ローカル';

  @override
  String get rankingOnlineTab => 'オンライン';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get onlineUnavailable => 'オンラインランキングは利用できません';

  @override
  String get ranking => 'ランキング';

  @override
  String get statistics => '統計情報';

  @override
  String get achievements => 'アチーブメント';

  @override
  String get howToPlay => '遊び方';

  @override
  String get settings => '設定';

  @override
  String get nextLabel => '次: ';

  @override
  String timeLabel(String time) {
    return 'タイム: $time';
  }

  @override
  String get clearTitle => 'クリア！';

  @override
  String get newAchievements => '🏆 新しいアチーブメント！';

  @override
  String get playAgain => 'もう一度';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get noRecordsYet => 'まだ記録がありません';

  @override
  String resetRankingTitle(String mode) {
    return '$modeのランキングをリセット';
  }

  @override
  String get resetRankingMessage => 'このモードのすべてのランキングをリセットしますか？\nこの操作は取り消せません。';

  @override
  String get shareRecord => '記録を共有';

  @override
  String get copiedToClipboard => '記録をクリップボードにコピーしました';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '【Touch the Number】$modeモードで $time を記録しました！（ランキング$rank位）\n数字を1から順にタップする脳トレタイムアタック、あなたも挑戦してみよう！\n#TouchTheNumber';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get reset => 'リセット';

  @override
  String get overallStats => '全体統計';

  @override
  String get totalPlays => '総プレイ回数';

  @override
  String get totalPlayTime => '総プレイ時間';

  @override
  String get statsByDifficulty => '難易度別統計';

  @override
  String get playCount => 'プレイ回数';

  @override
  String get bestTime => 'ベストタイム';

  @override
  String get averageTime => '平均タイム';

  @override
  String timesCount(int count) {
    return '$count回';
  }

  @override
  String get noData => 'データがありません';

  @override
  String get resetStatsTitle => '統計情報をリセット';

  @override
  String get resetStatsMessage => 'すべての統計情報をリセットしますか？\nこの操作は取り消せません。';

  @override
  String achievementProgress(int unlocked, int total) {
    return '達成: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return '達成日時: $date';
  }

  @override
  String get achFirstWinTitle => '初勝利';

  @override
  String get achFirstWinDesc => '初めてゲームをクリア';

  @override
  String get achSpeed10Title => 'スピードスター';

  @override
  String get achSpeed10Desc => '10秒以内にクリア';

  @override
  String get achSpeed20Title => 'スピードマスター';

  @override
  String get achSpeed20Desc => '20秒以内にクリア';

  @override
  String get achGames10Title => 'ゲーマー';

  @override
  String get achGames10Desc => '10回プレイ';

  @override
  String get achGames50Title => 'ベテラン';

  @override
  String get achGames50Desc => '50回プレイ';

  @override
  String get achGames100Title => 'レジェンド';

  @override
  String get achGames100Desc => '100回プレイ';

  @override
  String get achAllModesTitle => '万能プレイヤー';

  @override
  String get achAllModesDesc => 'すべてのモードでクリア';

  @override
  String get achPerfectDayTitle => 'パーフェクトデイ';

  @override
  String get achPerfectDayDesc => '1日に10回クリア';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get themeBlue => 'ブルー';

  @override
  String get themeGreen => 'グリーン';

  @override
  String get themePurple => 'パープル';

  @override
  String get themeOrange => 'オレンジ';

  @override
  String get themeRed => 'レッド';

  @override
  String get themePink => 'ピンク';

  @override
  String get themeTeal => 'ティール';

  @override
  String get themeIndigo => 'インディゴ';

  @override
  String get sound => 'サウンド';

  @override
  String get soundSubtitle => '効果音とバイブレーション';

  @override
  String get bgm => 'BGM';

  @override
  String get bgmSubtitle => 'タイトル・プレイ中の音楽';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システム設定に従う';

  @override
  String get tutGoalTitle => 'ゲームの目的';

  @override
  String get tutGoalDesc => '1から順番に数字をタップしていきます。\nすべての数字を正しい順番でタップすればクリアです！';

  @override
  String get tutTimeTitle => 'タイムを競おう';

  @override
  String get tutTimeDesc => 'できるだけ早くクリアすることを目指しましょう。\nタイムはミリ秒単位で記録されます。';

  @override
  String get tutRankingTitle => 'ランキング';

  @override
  String get tutRankingDesc => '各難易度のベスト10タイムが記録されます。\n自己ベストを目指して何度も挑戦しましょう！';

  @override
  String get tutAchievementsTitle => 'アチーブメント';

  @override
  String get tutAchievementsDesc =>
      '特定の条件を達成するとアチーブメントが解除されます。\nすべてのアチーブメントを集めましょう！';

  @override
  String get tutCustomizeTitle => 'カスタマイズ';

  @override
  String get tutCustomizeDesc => '設定画面からテーマカラーを変更できます。\nお好みの色でプレイしましょう！';

  @override
  String get back => '戻る';

  @override
  String get next => '次へ';

  @override
  String get done => '完了';

  @override
  String get muteTooltip => 'サウンドをオフ';

  @override
  String get unmuteTooltip => 'サウンドをオン';
}

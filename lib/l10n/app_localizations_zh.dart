// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => '选择游戏模式';

  @override
  String get ranking => '排行榜';

  @override
  String get statistics => '统计';

  @override
  String get achievements => '成就';

  @override
  String get howToPlay => '玩法说明';

  @override
  String get settings => '设置';

  @override
  String get nextLabel => '下一个: ';

  @override
  String timeLabel(String time) {
    return '时间: $time';
  }

  @override
  String get clearTitle => '通关！';

  @override
  String get newAchievements => '🏆 新成就！';

  @override
  String get playAgain => '再来一次';

  @override
  String get backToHome => '返回主页';

  @override
  String get noRecordsYet => '暂无记录';

  @override
  String resetRankingTitle(String mode) {
    return '重置$mode排行榜';
  }

  @override
  String get resetRankingMessage => '要重置此模式的所有排行榜吗？\n此操作无法撤销。';

  @override
  String get shareRecord => '分享记录';

  @override
  String get copiedToClipboard => '记录已复制到剪贴板';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '【Touch the Number】我在$mode模式中取得了$time的成绩！（排名第$rank位）\n从1开始按顺序点击数字的健脑计时游戏，你也来挑战吧！\n#TouchTheNumber';
  }

  @override
  String get cancel => '取消';

  @override
  String get reset => '重置';

  @override
  String get overallStats => '总体统计';

  @override
  String get totalPlays => '总游玩次数';

  @override
  String get totalPlayTime => '总游玩时间';

  @override
  String get statsByDifficulty => '按难度统计';

  @override
  String get playCount => '游玩次数';

  @override
  String get bestTime => '最佳时间';

  @override
  String get averageTime => '平均时间';

  @override
  String timesCount(int count) {
    return '$count次';
  }

  @override
  String get noData => '暂无数据';

  @override
  String get resetStatsTitle => '重置统计';

  @override
  String get resetStatsMessage => '要重置所有统计数据吗？\n此操作无法撤销。';

  @override
  String achievementProgress(int unlocked, int total) {
    return '已达成: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return '达成日期: $date';
  }

  @override
  String get achFirstWinTitle => '首次胜利';

  @override
  String get achFirstWinDesc => '首次通关游戏';

  @override
  String get achSpeed10Title => '闪电之星';

  @override
  String get achSpeed10Desc => '10秒内通关';

  @override
  String get achSpeed20Title => '速度大师';

  @override
  String get achSpeed20Desc => '20秒内通关';

  @override
  String get achGames10Title => '玩家';

  @override
  String get achGames10Desc => '游玩10次';

  @override
  String get achGames50Title => '老手';

  @override
  String get achGames50Desc => '游玩50次';

  @override
  String get achGames100Title => '传奇';

  @override
  String get achGames100Desc => '游玩100次';

  @override
  String get achAllModesTitle => '全能玩家';

  @override
  String get achAllModesDesc => '通关所有模式';

  @override
  String get achPerfectDayTitle => '完美一天';

  @override
  String get achPerfectDayDesc => '一天内通关10次';

  @override
  String get themeColor => '主题颜色';

  @override
  String get themeBlue => '蓝色';

  @override
  String get themeGreen => '绿色';

  @override
  String get themePurple => '紫色';

  @override
  String get themeOrange => '橙色';

  @override
  String get themeRed => '红色';

  @override
  String get themePink => '粉色';

  @override
  String get themeTeal => '青色';

  @override
  String get themeIndigo => '靛蓝';

  @override
  String get sound => '音效';

  @override
  String get soundSubtitle => '音效与振动';

  @override
  String get bgm => '背景音乐';

  @override
  String get bgmSubtitle => '标题与游戏中的音乐';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统设置';

  @override
  String get tutGoalTitle => '游戏目标';

  @override
  String get tutGoalDesc => '从1开始按顺序点击数字。\n按正确顺序点完所有数字即通关！';

  @override
  String get tutTimeTitle => '挑战时间';

  @override
  String get tutTimeDesc => '以最快速度通关吧。\n时间以毫秒为单位记录。';

  @override
  String get tutRankingTitle => '排行榜';

  @override
  String get tutRankingDesc => '每个难度都会保存前10名的成绩。\n不断挑战自己的最佳纪录吧！';

  @override
  String get tutAchievementsTitle => '成就';

  @override
  String get tutAchievementsDesc => '达成特定条件即可解锁成就。\n收集全部成就吧！';

  @override
  String get tutCustomizeTitle => '个性化';

  @override
  String get tutCustomizeDesc => '可以在设置中更改主题颜色。\n用喜欢的颜色游玩吧！';

  @override
  String get back => '返回';

  @override
  String get next => '下一页';

  @override
  String get done => '完成';

  @override
  String get muteTooltip => '关闭声音';

  @override
  String get unmuteTooltip => '开启声音';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => '選擇遊戲模式';

  @override
  String get ranking => '排行榜';

  @override
  String get statistics => '統計';

  @override
  String get achievements => '成就';

  @override
  String get howToPlay => '玩法說明';

  @override
  String get settings => '設定';

  @override
  String get nextLabel => '下一個: ';

  @override
  String timeLabel(String time) {
    return '時間: $time';
  }

  @override
  String get clearTitle => '過關！';

  @override
  String get newAchievements => '🏆 新成就！';

  @override
  String get playAgain => '再玩一次';

  @override
  String get backToHome => '返回首頁';

  @override
  String get noRecordsYet => '尚無紀錄';

  @override
  String resetRankingTitle(String mode) {
    return '重設$mode排行榜';
  }

  @override
  String get resetRankingMessage => '要重設此模式的所有排行榜嗎？\n此操作無法復原。';

  @override
  String get shareRecord => '分享紀錄';

  @override
  String get copiedToClipboard => '紀錄已複製到剪貼簿';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '【Touch the Number】我在$mode模式取得了$time的成績！（排名第$rank名）\n從1開始依序點擊數字的健腦計時遊戲，你也來挑戰吧！\n#TouchTheNumber';
  }

  @override
  String get cancel => '取消';

  @override
  String get reset => '重設';

  @override
  String get overallStats => '整體統計';

  @override
  String get totalPlays => '總遊玩次數';

  @override
  String get totalPlayTime => '總遊玩時間';

  @override
  String get statsByDifficulty => '依難度統計';

  @override
  String get playCount => '遊玩次數';

  @override
  String get bestTime => '最佳時間';

  @override
  String get averageTime => '平均時間';

  @override
  String timesCount(int count) {
    return '$count次';
  }

  @override
  String get noData => '尚無資料';

  @override
  String get resetStatsTitle => '重設統計';

  @override
  String get resetStatsMessage => '要重設所有統計資料嗎？\n此操作無法復原。';

  @override
  String achievementProgress(int unlocked, int total) {
    return '已達成: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return '達成日期: $date';
  }

  @override
  String get achFirstWinTitle => '首次勝利';

  @override
  String get achFirstWinDesc => '首次過關';

  @override
  String get achSpeed10Title => '閃電之星';

  @override
  String get achSpeed10Desc => '10秒內過關';

  @override
  String get achSpeed20Title => '速度大師';

  @override
  String get achSpeed20Desc => '20秒內過關';

  @override
  String get achGames10Title => '玩家';

  @override
  String get achGames10Desc => '遊玩10次';

  @override
  String get achGames50Title => '老手';

  @override
  String get achGames50Desc => '遊玩50次';

  @override
  String get achGames100Title => '傳奇';

  @override
  String get achGames100Desc => '遊玩100次';

  @override
  String get achAllModesTitle => '全能玩家';

  @override
  String get achAllModesDesc => '過關所有模式';

  @override
  String get achPerfectDayTitle => '完美的一天';

  @override
  String get achPerfectDayDesc => '一天內過關10次';

  @override
  String get themeColor => '主題顏色';

  @override
  String get themeBlue => '藍色';

  @override
  String get themeGreen => '綠色';

  @override
  String get themePurple => '紫色';

  @override
  String get themeOrange => '橙色';

  @override
  String get themeRed => '紅色';

  @override
  String get themePink => '粉紅色';

  @override
  String get themeTeal => '藍綠色';

  @override
  String get themeIndigo => '靛藍';

  @override
  String get sound => '音效';

  @override
  String get soundSubtitle => '音效與震動';

  @override
  String get bgm => '背景音樂';

  @override
  String get bgmSubtitle => '標題與遊戲中的音樂';

  @override
  String get language => '語言';

  @override
  String get languageSystem => '依系統設定';

  @override
  String get tutGoalTitle => '遊戲目標';

  @override
  String get tutGoalDesc => '從1開始依序點擊數字。\n依正確順序點完所有數字即過關！';

  @override
  String get tutTimeTitle => '挑戰時間';

  @override
  String get tutTimeDesc => '以最快速度過關吧。\n時間以毫秒為單位記錄。';

  @override
  String get tutRankingTitle => '排行榜';

  @override
  String get tutRankingDesc => '每個難度都會保存前10名的成績。\n不斷挑戰自己的最佳紀錄吧！';

  @override
  String get tutAchievementsTitle => '成就';

  @override
  String get tutAchievementsDesc => '達成特定條件即可解鎖成就。\n收集全部成就吧！';

  @override
  String get tutCustomizeTitle => '個人化';

  @override
  String get tutCustomizeDesc => '可以在設定中變更主題顏色。\n用喜歡的顏色遊玩吧！';

  @override
  String get back => '返回';

  @override
  String get next => '下一頁';

  @override
  String get done => '完成';

  @override
  String get muteTooltip => '關閉聲音';

  @override
  String get unmuteTooltip => '開啟聲音';
}

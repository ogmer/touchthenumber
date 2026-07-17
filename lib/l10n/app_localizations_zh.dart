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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'اختر وضع اللعب';

  @override
  String get difficultyEasy => 'مبتدئ';

  @override
  String get difficultyMedium => 'متوسط';

  @override
  String get difficultyHard => 'متقدم';

  @override
  String get countdownReady => 'هل أنت مستعد؟';

  @override
  String get countdownGo => 'ابدأ';

  @override
  String get newBestRecord => 'أفضل رقم جديد!';

  @override
  String behindBest(String time) {
    return 'على بعد $time من أفضل رقم';
  }

  @override
  String rankLabel(int rank) {
    return 'المركز #$rank';
  }

  @override
  String get almostFirst => 'Almost first place!';

  @override
  String get rankingLocalTab => 'محلي';

  @override
  String get rankingOnlineTab => 'متصل';

  @override
  String get nickname => 'الاسم المستعار';

  @override
  String get onlineUnavailable => 'الترتيب عبر الإنترنت غير متاح';

  @override
  String get ranking => 'التصنيف';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get howToPlay => 'طريقة اللعب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get nextLabel => 'التالي: ';

  @override
  String timeLabel(String time) {
    return 'الوقت: $time';
  }

  @override
  String get clearTitle => 'أحسنت!';

  @override
  String get newAchievements => '🏆 إنجازات جديدة!';

  @override
  String get playAgain => 'العب مجددًا';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get noRecordsYet => 'لا توجد أرقام قياسية بعد';

  @override
  String resetRankingTitle(String mode) {
    return 'إعادة تعيين تصنيف $mode';
  }

  @override
  String get resetRankingMessage =>
      'هل تريد إعادة تعيين جميع تصنيفات هذا الوضع؟\nلا يمكن التراجع عن هذا الإجراء.';

  @override
  String get shareRecord => 'مشاركة الرقم القياسي';

  @override
  String get copiedToClipboard => 'تم نسخ الرقم القياسي إلى الحافظة';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] حققت $time في وضع $mode! (المركز $rank)\nاضغط على الأرقام بالترتيب بدءًا من 1 في لعبة تدريب الدماغ ضد الوقت. جرّبها!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get overallStats => 'الإحصائيات العامة';

  @override
  String get totalPlays => 'إجمالي مرات اللعب';

  @override
  String get totalPlayTime => 'إجمالي وقت اللعب';

  @override
  String get statsByDifficulty => 'حسب الصعوبة';

  @override
  String get playCount => 'مرات اللعب';

  @override
  String get bestTime => 'أفضل وقت';

  @override
  String get averageTime => 'متوسط الوقت';

  @override
  String timesCount(int count) {
    return '$count مرة';
  }

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get resetStatsTitle => 'إعادة تعيين الإحصائيات';

  @override
  String get resetStatsMessage =>
      'هل تريد إعادة تعيين جميع الإحصائيات؟\nلا يمكن التراجع عن هذا الإجراء.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'المفتوحة: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'تم التحقيق في: $date';
  }

  @override
  String get achFirstWinTitle => 'الفوز الأول';

  @override
  String get achFirstWinDesc => 'أكمل اللعبة لأول مرة';

  @override
  String get achSpeed10Title => 'نجم السرعة';

  @override
  String get achSpeed10Desc => 'أكمل خلال 10 ثوانٍ';

  @override
  String get achSpeed20Title => 'سيد السرعة';

  @override
  String get achSpeed20Desc => 'أكمل خلال 20 ثانية';

  @override
  String get achGames10Title => 'لاعب';

  @override
  String get achGames10Desc => 'العب 10 مرات';

  @override
  String get achGames50Title => 'محترف';

  @override
  String get achGames50Desc => 'العب 50 مرة';

  @override
  String get achGames100Title => 'أسطورة';

  @override
  String get achGames100Desc => 'العب 100 مرة';

  @override
  String get achAllModesTitle => 'متعدد المواهب';

  @override
  String get achAllModesDesc => 'أكمل جميع الأوضاع';

  @override
  String get achPerfectDayTitle => 'يوم مثالي';

  @override
  String get achPerfectDayDesc => 'أكمل 10 مرات في يوم واحد';

  @override
  String get themeColor => 'لون السمة';

  @override
  String get themeBlue => 'أزرق';

  @override
  String get themeGreen => 'أخضر';

  @override
  String get themePurple => 'بنفسجي';

  @override
  String get themeOrange => 'برتقالي';

  @override
  String get themeRed => 'أحمر';

  @override
  String get themePink => 'وردي';

  @override
  String get themeTeal => 'أزرق مخضر';

  @override
  String get themeIndigo => 'نيلي';

  @override
  String get sound => 'الصوت';

  @override
  String get soundSubtitle => 'المؤثرات الصوتية والاهتزاز';

  @override
  String get bgm => 'الموسيقى';

  @override
  String get bgmSubtitle => 'موسيقى الواجهة واللعب';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'إعداد النظام';

  @override
  String get tutGoalTitle => 'الهدف';

  @override
  String get tutGoalDesc =>
      'اضغط على الأرقام بالترتيب بدءًا من 1.\nاضغط عليها كلها بالترتيب الصحيح للفوز!';

  @override
  String get tutTimeTitle => 'سباق مع الزمن';

  @override
  String get tutTimeDesc =>
      'حاول الإنهاء بأسرع ما يمكن.\nيُسجَّل وقتك بدقة الميلي ثانية.';

  @override
  String get tutRankingTitle => 'التصنيف';

  @override
  String get tutRankingDesc =>
      'تُحفظ أفضل 10 أوقات لكل صعوبة.\nحطّم رقمك القياسي!';

  @override
  String get tutAchievementsTitle => 'الإنجازات';

  @override
  String get tutAchievementsDesc =>
      'حقق أهدافًا محددة لفتح الإنجازات.\nاجمعها كلها!';

  @override
  String get tutCustomizeTitle => 'التخصيص';

  @override
  String get tutCustomizeDesc =>
      'غيّر لون السمة من الإعدادات.\nالعب بلونك المفضل!';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get muteTooltip => 'كتم الصوت';

  @override
  String get unmuteTooltip => 'تشغيل الصوت';
}

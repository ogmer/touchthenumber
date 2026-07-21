// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'गेम मोड चुनें';

  @override
  String get difficultyEasy => 'शुरुआती';

  @override
  String get difficultyMedium => 'मध्यम';

  @override
  String get difficultyHard => 'उन्नत';

  @override
  String get countdownReady => 'तैयार हैं?';

  @override
  String get countdownGo => 'शुरू!';

  @override
  String get newBestRecord => 'नया सर्वश्रेष्ठ!';

  @override
  String behindBest(String time) {
    return 'सर्वश्रेष्ठ से $time पीछे';
  }

  @override
  String rankLabel(int rank) {
    return 'रैंक #$rank';
  }

  @override
  String get rankingLocalTab => 'लोकल';

  @override
  String get rankingOnlineTab => 'ऑनलाइन';

  @override
  String get nickname => 'उपनाम';

  @override
  String get onlineUnavailable => 'ऑनलाइन रैंकिंग उपलब्ध नहीं है';

  @override
  String get ranking => 'रैंकिंग';

  @override
  String get statistics => 'आँकड़े';

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String get howToPlay => 'खेलने का तरीका';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get nextLabel => 'अगला: ';

  @override
  String timeLabel(String time) {
    return 'समय: $time';
  }

  @override
  String get clearTitle => 'पूरा हुआ!';

  @override
  String get newAchievements => '🏆 नई उपलब्धियाँ!';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get backToHome => 'होम पर जाएँ';

  @override
  String get noRecordsYet => 'अभी कोई रिकॉर्ड नहीं';

  @override
  String resetRankingTitle(String mode) {
    return '$mode रैंकिंग रीसेट करें';
  }

  @override
  String get resetRankingMessage =>
      'इस मोड की सभी रैंकिंग रीसेट करें?\nयह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get shareRecord => 'रिकॉर्ड साझा करें';

  @override
  String get copiedToClipboard => 'रिकॉर्ड क्लिपबोर्ड पर कॉपी हो गया';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] मैंने $mode मोड में $time का समय बनाया! (रैंक $rank)\n1 से क्रम में नंबर टैप करें — दिमाग़ी कसरत का टाइम अटैक। आज़माएँ!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get reset => 'रीसेट';

  @override
  String get overallStats => 'कुल आँकड़े';

  @override
  String get totalPlays => 'कुल खेल';

  @override
  String get totalPlayTime => 'कुल खेल समय';

  @override
  String get statsByDifficulty => 'कठिनाई के अनुसार';

  @override
  String get playCount => 'खेल';

  @override
  String get bestTime => 'सर्वश्रेष्ठ समय';

  @override
  String get averageTime => 'औसत समय';

  @override
  String timesCount(int count) {
    return '$count बार';
  }

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get resetStatsTitle => 'आँकड़े रीसेट करें';

  @override
  String get resetStatsMessage =>
      'सभी आँकड़े रीसेट करें?\nयह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'अनलॉक: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'प्राप्त: $date';
  }

  @override
  String get achFirstWinTitle => 'पहली जीत';

  @override
  String get achFirstWinDesc => 'पहली बार गेम पूरा करें';

  @override
  String get achSpeed10Title => 'स्पीड स्टार';

  @override
  String get achSpeed10Desc => '10 सेकंड में पूरा करें';

  @override
  String get achSpeed20Title => 'स्पीड मास्टर';

  @override
  String get achSpeed20Desc => '20 सेकंड में पूरा करें';

  @override
  String get achGames10Title => 'गेमर';

  @override
  String get achGames10Desc => '10 बार खेलें';

  @override
  String get achGames50Title => 'अनुभवी';

  @override
  String get achGames50Desc => '50 बार खेलें';

  @override
  String get achGames100Title => 'लीजेंड';

  @override
  String get achGames100Desc => '100 बार खेलें';

  @override
  String get achAllModesTitle => 'हरफ़नमौला';

  @override
  String get achAllModesDesc => 'सभी मोड पूरे करें';

  @override
  String get achPerfectDayTitle => 'परफेक्ट डे';

  @override
  String get achPerfectDayDesc => 'एक दिन में 10 बार पूरा करें';

  @override
  String get themeColor => 'थीम रंग';

  @override
  String get themeBlue => 'नीला';

  @override
  String get themeGreen => 'हरा';

  @override
  String get themePurple => 'बैंगनी';

  @override
  String get themeOrange => 'नारंगी';

  @override
  String get themeRed => 'लाल';

  @override
  String get themePink => 'गुलाबी';

  @override
  String get themeTeal => 'टील';

  @override
  String get themeIndigo => 'इंडिगो';

  @override
  String get sound => 'ध्वनि';

  @override
  String get soundSubtitle => 'ध्वनि प्रभाव और कंपन';

  @override
  String get bgm => 'संगीत';

  @override
  String get bgmSubtitle => 'टाइटल और गेम का संगीत';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get tutGoalTitle => 'लक्ष्य';

  @override
  String get tutGoalDesc =>
      '1 से शुरू करके क्रम में नंबर टैप करें।\nसभी को सही क्रम में टैप करें और जीतें!';

  @override
  String get tutTimeTitle => 'समय से मुक़ाबला';

  @override
  String get tutTimeDesc =>
      'जितनी जल्दी हो सके पूरा करें।\nसमय मिलीसेकंड तक दर्ज होता है।';

  @override
  String get tutRankingTitle => 'रैंकिंग';

  @override
  String get tutRankingDesc =>
      'हर कठिनाई के शीर्ष 10 समय सहेजे जाते हैं।\nअपना रिकॉर्ड तोड़ें!';

  @override
  String get tutAchievementsTitle => 'उपलब्धियाँ';

  @override
  String get tutAchievementsDesc =>
      'लक्ष्य पूरे करके उपलब्धियाँ अनलॉक करें।\nसभी इकट्ठा करें!';

  @override
  String get tutCustomizeTitle => 'कस्टमाइज़';

  @override
  String get tutCustomizeDesc =>
      'सेटिंग्स में थीम रंग बदलें।\nअपने पसंदीदा रंग में खेलें!';

  @override
  String get back => 'पीछे';

  @override
  String get next => 'आगे';

  @override
  String get done => 'पूर्ण';

  @override
  String get muteTooltip => 'ध्वनि बंद करें';

  @override
  String get unmuteTooltip => 'ध्वनि चालू करें';
}

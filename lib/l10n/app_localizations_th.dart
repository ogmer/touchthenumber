// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'เลือกโหมดเกม';

  @override
  String get difficultyEasy => 'มือใหม่';

  @override
  String get difficultyMedium => 'ระดับกลาง';

  @override
  String get difficultyHard => 'ระดับสูง';

  @override
  String get countdownReady => 'พร้อมไหม?';

  @override
  String get countdownGo => 'เริ่ม!';

  @override
  String get ranking => 'อันดับ';

  @override
  String get statistics => 'สถิติ';

  @override
  String get achievements => 'ความสำเร็จ';

  @override
  String get howToPlay => 'วิธีเล่น';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get nextLabel => 'ถัดไป: ';

  @override
  String timeLabel(String time) {
    return 'เวลา: $time';
  }

  @override
  String get clearTitle => 'สำเร็จ!';

  @override
  String get newAchievements => '🏆 ความสำเร็จใหม่!';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get backToHome => 'กลับหน้าหลัก';

  @override
  String get noRecordsYet => 'ยังไม่มีสถิติ';

  @override
  String resetRankingTitle(String mode) {
    return 'รีเซ็ตอันดับ $mode';
  }

  @override
  String get resetRankingMessage =>
      'รีเซ็ตอันดับทั้งหมดของโหมดนี้หรือไม่\nการดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get shareRecord => 'แชร์สถิติ';

  @override
  String get copiedToClipboard => 'คัดลอกสถิติไปยังคลิปบอร์ดแล้ว';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] ฉันทำเวลา $time ในโหมด $mode! (อันดับ $rank)\nแตะตัวเลขตามลำดับตั้งแต่ 1 เกมฝึกสมองแข่งกับเวลา มาลองกัน!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get reset => 'รีเซ็ต';

  @override
  String get overallStats => 'สถิติรวม';

  @override
  String get totalPlays => 'จำนวนครั้งที่เล่นทั้งหมด';

  @override
  String get totalPlayTime => 'เวลาเล่นทั้งหมด';

  @override
  String get statsByDifficulty => 'แยกตามระดับความยาก';

  @override
  String get playCount => 'จำนวนครั้งที่เล่น';

  @override
  String get bestTime => 'เวลาที่ดีที่สุด';

  @override
  String get averageTime => 'เวลาเฉลี่ย';

  @override
  String timesCount(int count) {
    return '$count ครั้ง';
  }

  @override
  String get noData => 'ไม่มีข้อมูล';

  @override
  String get resetStatsTitle => 'รีเซ็ตสถิติ';

  @override
  String get resetStatsMessage =>
      'รีเซ็ตสถิติทั้งหมดหรือไม่\nการดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'ปลดล็อกแล้ว: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'สำเร็จเมื่อ: $date';
  }

  @override
  String get achFirstWinTitle => 'ชัยชนะแรก';

  @override
  String get achFirstWinDesc => 'เล่นจบเกมเป็นครั้งแรก';

  @override
  String get achSpeed10Title => 'ดาวความเร็ว';

  @override
  String get achSpeed10Desc => 'จบภายใน 10 วินาที';

  @override
  String get achSpeed20Title => 'เจ้าแห่งความเร็ว';

  @override
  String get achSpeed20Desc => 'จบภายใน 20 วินาที';

  @override
  String get achGames10Title => 'เกมเมอร์';

  @override
  String get achGames10Desc => 'เล่น 10 ครั้ง';

  @override
  String get achGames50Title => 'มือเก๋า';

  @override
  String get achGames50Desc => 'เล่น 50 ครั้ง';

  @override
  String get achGames100Title => 'ตำนาน';

  @override
  String get achGames100Desc => 'เล่น 100 ครั้ง';

  @override
  String get achAllModesTitle => 'รอบด้าน';

  @override
  String get achAllModesDesc => 'เล่นจบทุกโหมด';

  @override
  String get achPerfectDayTitle => 'วันที่สมบูรณ์แบบ';

  @override
  String get achPerfectDayDesc => 'เล่นจบ 10 ครั้งในหนึ่งวัน';

  @override
  String get themeColor => 'สีธีม';

  @override
  String get themeBlue => 'น้ำเงิน';

  @override
  String get themeGreen => 'เขียว';

  @override
  String get themePurple => 'ม่วง';

  @override
  String get themeOrange => 'ส้ม';

  @override
  String get themeRed => 'แดง';

  @override
  String get themePink => 'ชมพู';

  @override
  String get themeTeal => 'น้ำเงินเขียว';

  @override
  String get themeIndigo => 'คราม';

  @override
  String get sound => 'เสียง';

  @override
  String get soundSubtitle => 'เอฟเฟกต์เสียงและการสั่น';

  @override
  String get bgm => 'เพลง';

  @override
  String get bgmSubtitle => 'เพลงหน้าแรกและระหว่างเล่น';

  @override
  String get language => 'ภาษา';

  @override
  String get languageSystem => 'ตามการตั้งค่าระบบ';

  @override
  String get tutGoalTitle => 'เป้าหมาย';

  @override
  String get tutGoalDesc =>
      'แตะตัวเลขตามลำดับโดยเริ่มจาก 1\nแตะให้ครบตามลำดับที่ถูกต้องเพื่อชนะ!';

  @override
  String get tutTimeTitle => 'แข่งกับเวลา';

  @override
  String get tutTimeDesc =>
      'พยายามจบให้เร็วที่สุด\nเวลาถูกบันทึกละเอียดถึงมิลลิวินาที';

  @override
  String get tutRankingTitle => 'อันดับ';

  @override
  String get tutRankingDesc =>
      'บันทึกเวลาที่ดีที่สุด 10 อันดับของแต่ละระดับ\nทำลายสถิติของตัวเองกัน!';

  @override
  String get tutAchievementsTitle => 'ความสำเร็จ';

  @override
  String get tutAchievementsDesc =>
      'ทำตามเงื่อนไขเพื่อปลดล็อกความสำเร็จ\nสะสมให้ครบทุกอัน!';

  @override
  String get tutCustomizeTitle => 'ปรับแต่ง';

  @override
  String get tutCustomizeDesc =>
      'เปลี่ยนสีธีมได้ในการตั้งค่า\nเล่นด้วยสีที่ชอบ!';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get next => 'ถัดไป';

  @override
  String get done => 'เสร็จสิ้น';

  @override
  String get muteTooltip => 'ปิดเสียง';

  @override
  String get unmuteTooltip => 'เปิดเสียง';
}

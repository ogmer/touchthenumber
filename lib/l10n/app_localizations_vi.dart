// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Chọn chế độ chơi';

  @override
  String get ranking => 'Bảng xếp hạng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get achievements => 'Thành tựu';

  @override
  String get howToPlay => 'Cách chơi';

  @override
  String get settings => 'Cài đặt';

  @override
  String get nextLabel => 'Tiếp: ';

  @override
  String timeLabel(String time) {
    return 'Thời gian: $time';
  }

  @override
  String get clearTitle => 'Hoàn thành!';

  @override
  String get newAchievements => '🏆 Thành tựu mới!';

  @override
  String get playAgain => 'Chơi lại';

  @override
  String get backToHome => 'Về trang chủ';

  @override
  String get noRecordsYet => 'Chưa có kỷ lục';

  @override
  String resetRankingTitle(String mode) {
    return 'Đặt lại bảng xếp hạng $mode';
  }

  @override
  String get resetRankingMessage =>
      'Đặt lại toàn bộ bảng xếp hạng của chế độ này?\nHành động này không thể hoàn tác.';

  @override
  String get shareRecord => 'Chia sẻ kỷ lục';

  @override
  String get copiedToClipboard => 'Đã sao chép kỷ lục vào bộ nhớ tạm';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Mình đạt $time ở chế độ $mode! (Hạng $rank)\nChạm các con số theo thứ tự từ 1 trong trò luyện não tính giờ này. Thử ngay nhé!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get reset => 'Đặt lại';

  @override
  String get overallStats => 'Thống kê chung';

  @override
  String get totalPlays => 'Tổng số lượt chơi';

  @override
  String get totalPlayTime => 'Tổng thời gian chơi';

  @override
  String get statsByDifficulty => 'Theo độ khó';

  @override
  String get playCount => 'Lượt chơi';

  @override
  String get bestTime => 'Thời gian tốt nhất';

  @override
  String get averageTime => 'Thời gian trung bình';

  @override
  String timesCount(int count) {
    return '$count lần';
  }

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get resetStatsTitle => 'Đặt lại thống kê';

  @override
  String get resetStatsMessage =>
      'Đặt lại toàn bộ thống kê?\nHành động này không thể hoàn tác.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Đã mở khóa: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Đạt được: $date';
  }

  @override
  String get achFirstWinTitle => 'Chiến thắng đầu tiên';

  @override
  String get achFirstWinDesc => 'Hoàn thành trò chơi lần đầu';

  @override
  String get achSpeed10Title => 'Ngôi sao tốc độ';

  @override
  String get achSpeed10Desc => 'Hoàn thành trong 10 giây';

  @override
  String get achSpeed20Title => 'Bậc thầy tốc độ';

  @override
  String get achSpeed20Desc => 'Hoàn thành trong 20 giây';

  @override
  String get achGames10Title => 'Game thủ';

  @override
  String get achGames10Desc => 'Chơi 10 lần';

  @override
  String get achGames50Title => 'Kỳ cựu';

  @override
  String get achGames50Desc => 'Chơi 50 lần';

  @override
  String get achGames100Title => 'Huyền thoại';

  @override
  String get achGames100Desc => 'Chơi 100 lần';

  @override
  String get achAllModesTitle => 'Đa tài';

  @override
  String get achAllModesDesc => 'Hoàn thành mọi chế độ';

  @override
  String get achPerfectDayTitle => 'Ngày hoàn hảo';

  @override
  String get achPerfectDayDesc => 'Hoàn thành 10 lần trong một ngày';

  @override
  String get themeColor => 'Màu chủ đề';

  @override
  String get themeBlue => 'Xanh dương';

  @override
  String get themeGreen => 'Xanh lá';

  @override
  String get themePurple => 'Tím';

  @override
  String get themeOrange => 'Cam';

  @override
  String get themeRed => 'Đỏ';

  @override
  String get themePink => 'Hồng';

  @override
  String get themeTeal => 'Xanh mòng két';

  @override
  String get themeIndigo => 'Chàm';

  @override
  String get sound => 'Âm thanh';

  @override
  String get soundSubtitle => 'Hiệu ứng âm thanh và rung';

  @override
  String get bgm => 'Nhạc nền';

  @override
  String get bgmSubtitle => 'Nhạc màn hình chính và trong game';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get tutGoalTitle => 'Mục tiêu';

  @override
  String get tutGoalDesc =>
      'Chạm các con số theo thứ tự bắt đầu từ 1.\nChạm đúng thứ tự tất cả các số để chiến thắng!';

  @override
  String get tutTimeTitle => 'Đua với thời gian';

  @override
  String get tutTimeDesc =>
      'Cố gắng hoàn thành nhanh nhất có thể.\nThời gian được ghi chính xác đến mili giây.';

  @override
  String get tutRankingTitle => 'Bảng xếp hạng';

  @override
  String get tutRankingDesc =>
      '10 thời gian tốt nhất được lưu theo từng độ khó.\nPhá kỷ lục cá nhân của bạn!';

  @override
  String get tutAchievementsTitle => 'Thành tựu';

  @override
  String get tutAchievementsDesc =>
      'Đạt các điều kiện để mở khóa thành tựu.\nSưu tầm tất cả nhé!';

  @override
  String get tutCustomizeTitle => 'Tùy chỉnh';

  @override
  String get tutCustomizeDesc =>
      'Đổi màu chủ đề trong cài đặt.\nChơi với màu bạn thích!';

  @override
  String get back => 'Quay lại';

  @override
  String get next => 'Tiếp theo';

  @override
  String get done => 'Xong';

  @override
  String get muteTooltip => 'Tắt âm';

  @override
  String get unmuteTooltip => 'Bật âm';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => '게임 모드 선택';

  @override
  String get difficultyEasy => '초급';

  @override
  String get difficultyMedium => '중급';

  @override
  String get difficultyHard => '고급';

  @override
  String get countdownReady => '준비됐나요?';

  @override
  String get countdownGo => '시작!';

  @override
  String get ranking => '랭킹';

  @override
  String get statistics => '통계';

  @override
  String get achievements => '업적';

  @override
  String get howToPlay => '게임 방법';

  @override
  String get settings => '설정';

  @override
  String get nextLabel => '다음: ';

  @override
  String timeLabel(String time) {
    return '시간: $time';
  }

  @override
  String get clearTitle => '클리어!';

  @override
  String get newAchievements => '🏆 새로운 업적!';

  @override
  String get playAgain => '다시 하기';

  @override
  String get backToHome => '홈으로';

  @override
  String get noRecordsYet => '아직 기록이 없습니다';

  @override
  String resetRankingTitle(String mode) {
    return '$mode 랭킹 초기화';
  }

  @override
  String get resetRankingMessage => '이 모드의 모든 랭킹을 초기화할까요?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get shareRecord => '기록 공유';

  @override
  String get copiedToClipboard => '기록이 클립보드에 복사되었습니다';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] $mode 모드에서 $time 기록 달성! (랭킹 $rank위)\n1부터 순서대로 숫자를 터치하는 두뇌 트레이닝 타임어택, 도전해 보세요!\n#TouchTheNumber';
  }

  @override
  String get cancel => '취소';

  @override
  String get reset => '초기화';

  @override
  String get overallStats => '전체 통계';

  @override
  String get totalPlays => '총 플레이 횟수';

  @override
  String get totalPlayTime => '총 플레이 시간';

  @override
  String get statsByDifficulty => '난이도별 통계';

  @override
  String get playCount => '플레이 횟수';

  @override
  String get bestTime => '최고 기록';

  @override
  String get averageTime => '평균 기록';

  @override
  String timesCount(int count) {
    return '$count회';
  }

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get resetStatsTitle => '통계 초기화';

  @override
  String get resetStatsMessage => '모든 통계를 초기화할까요?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String achievementProgress(int unlocked, int total) {
    return '달성: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return '달성일: $date';
  }

  @override
  String get achFirstWinTitle => '첫 승리';

  @override
  String get achFirstWinDesc => '처음으로 게임 클리어';

  @override
  String get achSpeed10Title => '스피드 스타';

  @override
  String get achSpeed10Desc => '10초 이내 클리어';

  @override
  String get achSpeed20Title => '스피드 마스터';

  @override
  String get achSpeed20Desc => '20초 이내 클리어';

  @override
  String get achGames10Title => '게이머';

  @override
  String get achGames10Desc => '10회 플레이';

  @override
  String get achGames50Title => '베테랑';

  @override
  String get achGames50Desc => '50회 플레이';

  @override
  String get achGames100Title => '레전드';

  @override
  String get achGames100Desc => '100회 플레이';

  @override
  String get achAllModesTitle => '만능 플레이어';

  @override
  String get achAllModesDesc => '모든 모드 클리어';

  @override
  String get achPerfectDayTitle => '퍼펙트 데이';

  @override
  String get achPerfectDayDesc => '하루에 10회 클리어';

  @override
  String get themeColor => '테마 색상';

  @override
  String get themeBlue => '블루';

  @override
  String get themeGreen => '그린';

  @override
  String get themePurple => '퍼플';

  @override
  String get themeOrange => '오렌지';

  @override
  String get themeRed => '레드';

  @override
  String get themePink => '핑크';

  @override
  String get themeTeal => '틸';

  @override
  String get themeIndigo => '인디고';

  @override
  String get sound => '사운드';

  @override
  String get soundSubtitle => '효과음과 진동';

  @override
  String get bgm => '배경음악';

  @override
  String get bgmSubtitle => '타이틀·게임 중 음악';

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템 설정에 따름';

  @override
  String get tutGoalTitle => '게임 목표';

  @override
  String get tutGoalDesc => '1부터 순서대로 숫자를 터치하세요.\n모든 숫자를 올바른 순서로 터치하면 클리어!';

  @override
  String get tutTimeTitle => '기록에 도전';

  @override
  String get tutTimeDesc => '최대한 빠르게 클리어해 보세요.\n기록은 밀리초 단위로 저장됩니다.';

  @override
  String get tutRankingTitle => '랭킹';

  @override
  String get tutRankingDesc => '난이도별로 상위 10개의 기록이 저장됩니다.\n자신의 최고 기록에 도전하세요!';

  @override
  String get tutAchievementsTitle => '업적';

  @override
  String get tutAchievementsDesc => '특정 조건을 달성하면 업적이 해제됩니다.\n모든 업적을 모아 보세요!';

  @override
  String get tutCustomizeTitle => '커스터마이즈';

  @override
  String get tutCustomizeDesc => '설정에서 테마 색상을 바꿀 수 있습니다.\n좋아하는 색으로 플레이하세요!';

  @override
  String get back => '이전';

  @override
  String get next => '다음';

  @override
  String get done => '완료';

  @override
  String get muteTooltip => '소리 끄기';

  @override
  String get unmuteTooltip => '소리 켜기';
}

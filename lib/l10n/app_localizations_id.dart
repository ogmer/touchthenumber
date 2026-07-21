// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Pilih mode permainan';

  @override
  String get difficultyEasy => 'Pemula';

  @override
  String get difficultyMedium => 'Menengah';

  @override
  String get difficultyHard => 'Mahir';

  @override
  String get countdownReady => 'Siap?';

  @override
  String get countdownGo => 'Mulai!';

  @override
  String get ranking => 'Peringkat';

  @override
  String get statistics => 'Statistik';

  @override
  String get achievements => 'Pencapaian';

  @override
  String get howToPlay => 'Cara bermain';

  @override
  String get settings => 'Pengaturan';

  @override
  String get nextLabel => 'Berikutnya: ';

  @override
  String timeLabel(String time) {
    return 'Waktu: $time';
  }

  @override
  String get clearTitle => 'Selesai!';

  @override
  String get newAchievements => '🏆 Pencapaian baru!';

  @override
  String get playAgain => 'Main lagi';

  @override
  String get backToHome => 'Kembali ke beranda';

  @override
  String get noRecordsYet => 'Belum ada rekor';

  @override
  String resetRankingTitle(String mode) {
    return 'Atur ulang peringkat $mode';
  }

  @override
  String get resetRankingMessage =>
      'Atur ulang semua peringkat mode ini?\nTindakan ini tidak dapat dibatalkan.';

  @override
  String get shareRecord => 'Bagikan rekor';

  @override
  String get copiedToClipboard => 'Rekor disalin ke papan klip';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Aku mencetak $time di mode $mode! (Peringkat $rank)\nKetuk angka berurutan mulai dari 1 dalam permainan asah otak melawan waktu ini. Coba yuk!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get reset => 'Atur ulang';

  @override
  String get overallStats => 'Statistik keseluruhan';

  @override
  String get totalPlays => 'Total permainan';

  @override
  String get totalPlayTime => 'Total waktu bermain';

  @override
  String get statsByDifficulty => 'Per tingkat kesulitan';

  @override
  String get playCount => 'Permainan';

  @override
  String get bestTime => 'Waktu terbaik';

  @override
  String get averageTime => 'Waktu rata-rata';

  @override
  String timesCount(int count) {
    return '$count kali';
  }

  @override
  String get noData => 'Tidak ada data';

  @override
  String get resetStatsTitle => 'Atur ulang statistik';

  @override
  String get resetStatsMessage =>
      'Atur ulang semua statistik?\nTindakan ini tidak dapat dibatalkan.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Terbuka: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Dicapai: $date';
  }

  @override
  String get achFirstWinTitle => 'Kemenangan pertama';

  @override
  String get achFirstWinDesc => 'Selesaikan permainan untuk pertama kalinya';

  @override
  String get achSpeed10Title => 'Bintang kecepatan';

  @override
  String get achSpeed10Desc => 'Selesaikan dalam 10 detik';

  @override
  String get achSpeed20Title => 'Master kecepatan';

  @override
  String get achSpeed20Desc => 'Selesaikan dalam 20 detik';

  @override
  String get achGames10Title => 'Gamer';

  @override
  String get achGames10Desc => 'Main 10 kali';

  @override
  String get achGames50Title => 'Veteran';

  @override
  String get achGames50Desc => 'Main 50 kali';

  @override
  String get achGames100Title => 'Legenda';

  @override
  String get achGames100Desc => 'Main 100 kali';

  @override
  String get achAllModesTitle => 'Serba bisa';

  @override
  String get achAllModesDesc => 'Selesaikan semua mode';

  @override
  String get achPerfectDayTitle => 'Hari sempurna';

  @override
  String get achPerfectDayDesc => 'Selesaikan 10 kali dalam sehari';

  @override
  String get themeColor => 'Warna tema';

  @override
  String get themeBlue => 'Biru';

  @override
  String get themeGreen => 'Hijau';

  @override
  String get themePurple => 'Ungu';

  @override
  String get themeOrange => 'Oranye';

  @override
  String get themeRed => 'Merah';

  @override
  String get themePink => 'Merah muda';

  @override
  String get themeTeal => 'Toska';

  @override
  String get themeIndigo => 'Nila';

  @override
  String get sound => 'Suara';

  @override
  String get soundSubtitle => 'Efek suara dan getaran';

  @override
  String get bgm => 'Musik';

  @override
  String get bgmSubtitle => 'Musik judul dan permainan';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Bawaan sistem';

  @override
  String get tutGoalTitle => 'Tujuan';

  @override
  String get tutGoalDesc =>
      'Ketuk angka secara berurutan mulai dari 1.\nKetuk semuanya dalam urutan yang benar untuk menang!';

  @override
  String get tutTimeTitle => 'Melawan waktu';

  @override
  String get tutTimeDesc =>
      'Selesaikan secepat mungkin.\nWaktumu dicatat hingga milidetik.';

  @override
  String get tutRankingTitle => 'Peringkat';

  @override
  String get tutRankingDesc =>
      '10 waktu terbaikmu disimpan per tingkat kesulitan.\nPecahkan rekor pribadimu!';

  @override
  String get tutAchievementsTitle => 'Pencapaian';

  @override
  String get tutAchievementsDesc =>
      'Capai target tertentu untuk membuka pencapaian.\nKumpulkan semuanya!';

  @override
  String get tutCustomizeTitle => 'Kustomisasi';

  @override
  String get tutCustomizeDesc =>
      'Ubah warna tema di pengaturan.\nMain dengan warna favoritmu!';

  @override
  String get back => 'Kembali';

  @override
  String get next => 'Lanjut';

  @override
  String get done => 'Selesai';

  @override
  String get muteTooltip => 'Bisukan';

  @override
  String get unmuteTooltip => 'Nyalakan suara';
}

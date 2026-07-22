// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Spielmodus wählen';

  @override
  String get difficultyEasy => 'Anfänger';

  @override
  String get difficultyMedium => 'Fortgeschritten';

  @override
  String get difficultyHard => 'Experte';

  @override
  String get countdownReady => 'Bereit?';

  @override
  String get countdownGo => 'Los!';

  @override
  String get newBestRecord => 'Neuer Rekord!';

  @override
  String behindBest(String time) {
    return '$time vom Rekord entfernt';
  }

  @override
  String rankLabel(int rank) {
    return 'Rang #$rank';
  }

  @override
  String get almostFirst => 'Almost first place!';

  @override
  String get rankingLocalTab => 'Lokal';

  @override
  String get rankingOnlineTab => 'Online';

  @override
  String get nickname => 'Spitzname';

  @override
  String get onlineUnavailable => 'Online-Rangliste nicht verfügbar';

  @override
  String get ranking => 'Rangliste';

  @override
  String get statistics => 'Statistiken';

  @override
  String get achievements => 'Erfolge';

  @override
  String get howToPlay => 'Spielanleitung';

  @override
  String get settings => 'Einstellungen';

  @override
  String get nextLabel => 'Nächste: ';

  @override
  String timeLabel(String time) {
    return 'Zeit: $time';
  }

  @override
  String get clearTitle => 'Geschafft!';

  @override
  String get newAchievements => '🏆 Neue Erfolge!';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get backToHome => 'Zur Startseite';

  @override
  String get noRecordsYet => 'Noch keine Rekorde';

  @override
  String resetRankingTitle(String mode) {
    return '$mode-Rangliste zurücksetzen';
  }

  @override
  String get resetRankingMessage =>
      'Alle Ranglisten dieses Modus zurücksetzen?\nDies kann nicht rückgängig gemacht werden.';

  @override
  String get shareRecord => 'Rekord teilen';

  @override
  String get copiedToClipboard => 'Rekord in die Zwischenablage kopiert';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Ich habe $time im Modus $mode geschafft! (Platz $rank)\nTippe die Zahlen ab 1 der Reihe nach an – ein Gehirntraining gegen die Zeit. Probier es aus!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get overallStats => 'Gesamtstatistik';

  @override
  String get totalPlays => 'Gespielte Runden';

  @override
  String get totalPlayTime => 'Gesamtspielzeit';

  @override
  String get statsByDifficulty => 'Nach Schwierigkeit';

  @override
  String get playCount => 'Runden';

  @override
  String get bestTime => 'Bestzeit';

  @override
  String get averageTime => 'Durchschnittszeit';

  @override
  String timesCount(int count) {
    return '$count Mal';
  }

  @override
  String get noData => 'Keine Daten';

  @override
  String get resetStatsTitle => 'Statistiken zurücksetzen';

  @override
  String get resetStatsMessage =>
      'Alle Statistiken zurücksetzen?\nDies kann nicht rückgängig gemacht werden.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Freigeschaltet: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Erreicht am: $date';
  }

  @override
  String get achFirstWinTitle => 'Erster Sieg';

  @override
  String get achFirstWinDesc => 'Schließe das Spiel zum ersten Mal ab';

  @override
  String get achSpeed10Title => 'Blitzstern';

  @override
  String get achSpeed10Desc => 'In unter 10 Sekunden abschließen';

  @override
  String get achSpeed20Title => 'Tempo-Meister';

  @override
  String get achSpeed20Desc => 'In unter 20 Sekunden abschließen';

  @override
  String get achGames10Title => 'Spieler';

  @override
  String get achGames10Desc => 'Spiele 10 Runden';

  @override
  String get achGames50Title => 'Veteran';

  @override
  String get achGames50Desc => 'Spiele 50 Runden';

  @override
  String get achGames100Title => 'Legende';

  @override
  String get achGames100Desc => 'Spiele 100 Runden';

  @override
  String get achAllModesTitle => 'Allrounder';

  @override
  String get achAllModesDesc => 'Schließe jeden Modus ab';

  @override
  String get achPerfectDayTitle => 'Perfekter Tag';

  @override
  String get achPerfectDayDesc => 'Schließe 10 Runden an einem Tag ab';

  @override
  String get themeColor => 'Themenfarbe';

  @override
  String get themeBlue => 'Blau';

  @override
  String get themeGreen => 'Grün';

  @override
  String get themePurple => 'Lila';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeRed => 'Rot';

  @override
  String get themePink => 'Rosa';

  @override
  String get themeTeal => 'Türkis';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get sound => 'Ton';

  @override
  String get soundSubtitle => 'Soundeffekte und Vibration';

  @override
  String get bgm => 'Musik';

  @override
  String get bgmSubtitle => 'Titel- und Spielmusik';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get tutGoalTitle => 'Ziel';

  @override
  String get tutGoalDesc =>
      'Tippe die Zahlen der Reihe nach an, beginnend bei 1.\nTippe alle in der richtigen Reihenfolge, um zu gewinnen!';

  @override
  String get tutTimeTitle => 'Gegen die Zeit';

  @override
  String get tutTimeDesc =>
      'Versuche, so schnell wie möglich fertig zu werden.\nDeine Zeit wird auf die Millisekunde genau erfasst.';

  @override
  String get tutRankingTitle => 'Rangliste';

  @override
  String get tutRankingDesc =>
      'Deine 10 besten Zeiten werden pro Schwierigkeit gespeichert.\nKnacke deinen persönlichen Rekord!';

  @override
  String get tutAchievementsTitle => 'Erfolge';

  @override
  String get tutAchievementsDesc =>
      'Erfülle bestimmte Ziele, um Erfolge freizuschalten.\nSammle sie alle!';

  @override
  String get tutCustomizeTitle => 'Anpassen';

  @override
  String get tutCustomizeDesc =>
      'Ändere die Themenfarbe in den Einstellungen.\nSpiele in deiner Lieblingsfarbe!';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get muteTooltip => 'Ton aus';

  @override
  String get unmuteTooltip => 'Ton ein';
}

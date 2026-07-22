// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Scegli la modalità di gioco';

  @override
  String get difficultyEasy => 'Principiante';

  @override
  String get difficultyMedium => 'Intermedio';

  @override
  String get difficultyHard => 'Avanzato';

  @override
  String get countdownReady => 'Are you ready？';

  @override
  String get countdownGo => 'Via!';

  @override
  String get newBestRecord => 'Nuovo record!';

  @override
  String behindBest(String time) {
    return 'a $time dal record';
  }

  @override
  String rankLabel(int rank) {
    return 'Posizione #$rank';
  }

  @override
  String get almostFirst => 'Quasi primo!';

  @override
  String get rankingLocalTab => 'Locale';

  @override
  String get rankingOnlineTab => 'Online';

  @override
  String get nickname => 'Nickname';

  @override
  String get onlineUnavailable => 'Classifica online non disponibile';

  @override
  String get ranking => 'Classifica';

  @override
  String get statistics => 'Statistiche';

  @override
  String get achievements => 'Obiettivi';

  @override
  String get howToPlay => 'Come si gioca';

  @override
  String get settings => 'Impostazioni';

  @override
  String get nextLabel => 'Succ.: ';

  @override
  String timeLabel(String time) {
    return 'Tempo: $time';
  }

  @override
  String get clearTitle => 'Completato!';

  @override
  String get newAchievements => '🏆 Nuovi obiettivi!';

  @override
  String get playAgain => 'Gioca ancora';

  @override
  String get backToHome => 'Torna alla home';

  @override
  String get noRecordsYet => 'Ancora nessun record';

  @override
  String resetRankingTitle(String mode) {
    return 'Azzera la classifica $mode';
  }

  @override
  String get resetRankingMessage =>
      'Azzerare tutte le classifiche di questa modalità?\nL\'operazione non può essere annullata.';

  @override
  String get shareRecord => 'Condividi record';

  @override
  String get copiedToClipboard => 'Record copiato negli appunti';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Ho fatto $time in modalità $mode! (Posizione n.$rank)\nTocca i numeri in ordine dall\'1 in questo allenamento mentale a tempo. Provalo!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get reset => 'Azzera';

  @override
  String get overallStats => 'Statistiche generali';

  @override
  String get totalPlays => 'Partite totali';

  @override
  String get totalPlayTime => 'Tempo di gioco totale';

  @override
  String get statsByDifficulty => 'Per difficoltà';

  @override
  String get playCount => 'Partite';

  @override
  String get bestTime => 'Miglior tempo';

  @override
  String get averageTime => 'Tempo medio';

  @override
  String timesCount(int count) {
    return '$count volte';
  }

  @override
  String get noData => 'Nessun dato';

  @override
  String get resetStatsTitle => 'Azzera statistiche';

  @override
  String get resetStatsMessage =>
      'Azzerare tutte le statistiche?\nL\'operazione non può essere annullata.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Sbloccati: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Ottenuto: $date';
  }

  @override
  String get achFirstWinTitle => 'Prima vittoria';

  @override
  String get achFirstWinDesc => 'Completa il gioco per la prima volta';

  @override
  String get achSpeed10Title => 'Stella della velocità';

  @override
  String get achSpeed10Desc => 'Completa in meno di 10 secondi';

  @override
  String get achSpeed20Title => 'Maestro di velocità';

  @override
  String get achSpeed20Desc => 'Completa in meno di 20 secondi';

  @override
  String get achGames10Title => 'Giocatore';

  @override
  String get achGames10Desc => 'Gioca 10 partite';

  @override
  String get achGames50Title => 'Veterano';

  @override
  String get achGames50Desc => 'Gioca 50 partite';

  @override
  String get achGames100Title => 'Leggenda';

  @override
  String get achGames100Desc => 'Gioca 100 partite';

  @override
  String get achAllModesTitle => 'Tuttofare';

  @override
  String get achAllModesDesc => 'Completa tutte le modalità';

  @override
  String get achPerfectDayTitle => 'Giornata perfetta';

  @override
  String get achPerfectDayDesc => 'Completa 10 partite in un giorno';

  @override
  String get themeColor => 'Colore del tema';

  @override
  String get themeBlue => 'Blu';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themePurple => 'Viola';

  @override
  String get themeOrange => 'Arancione';

  @override
  String get themeRed => 'Rosso';

  @override
  String get themePink => 'Rosa';

  @override
  String get themeTeal => 'Verde acqua';

  @override
  String get themeIndigo => 'Indaco';

  @override
  String get sound => 'Suono';

  @override
  String get soundSubtitle => 'Effetti sonori e vibrazione';

  @override
  String get bgm => 'Musica';

  @override
  String get bgmSubtitle => 'Musica del titolo e di gioco';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Predefinita di sistema';

  @override
  String get tutGoalTitle => 'Obiettivo';

  @override
  String get tutGoalDesc =>
      'Tocca i numeri in ordine partendo dall\'1.\nToccali tutti nell\'ordine giusto per vincere!';

  @override
  String get tutTimeTitle => 'Contro il tempo';

  @override
  String get tutTimeDesc =>
      'Cerca di finire il più in fretta possibile.\nIl tempo è registrato al millisecondo.';

  @override
  String get tutRankingTitle => 'Classifica';

  @override
  String get tutRankingDesc =>
      'I tuoi 10 tempi migliori vengono salvati per difficoltà.\nBatti il tuo record personale!';

  @override
  String get tutAchievementsTitle => 'Obiettivi';

  @override
  String get tutAchievementsDesc =>
      'Raggiungi determinati traguardi per sbloccare gli obiettivi.\nCollezionali tutti!';

  @override
  String get tutCustomizeTitle => 'Personalizza';

  @override
  String get tutCustomizeDesc =>
      'Cambia il colore del tema nelle impostazioni.\nGioca con il tuo colore preferito!';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get done => 'Fine';

  @override
  String get muteTooltip => 'Disattiva audio';

  @override
  String get unmuteTooltip => 'Attiva audio';
}

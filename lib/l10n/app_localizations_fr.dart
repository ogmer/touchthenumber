// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Choisissez un mode de jeu';

  @override
  String get ranking => 'Classement';

  @override
  String get statistics => 'Statistiques';

  @override
  String get achievements => 'Succès';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get settings => 'Paramètres';

  @override
  String get nextLabel => 'Suiv. : ';

  @override
  String timeLabel(String time) {
    return 'Temps : $time';
  }

  @override
  String get clearTitle => 'Terminé !';

  @override
  String get newAchievements => '🏆 Nouveaux succès !';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get noRecordsYet => 'Aucun record pour le moment';

  @override
  String resetRankingTitle(String mode) {
    return 'Réinitialiser le classement $mode';
  }

  @override
  String get resetRankingMessage =>
      'Réinitialiser tous les classements de ce mode ?\nCette action est irréversible.';

  @override
  String get shareRecord => 'Partager le record';

  @override
  String get copiedToClipboard => 'Record copié dans le presse-papiers';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] J\'ai fait $time en mode $mode ! (Rang n°$rank)\nTouchez les chiffres dans l\'ordre à partir de 1 dans ce jeu d\'entraînement cérébral. Essayez !\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get overallStats => 'Vue d\'ensemble';

  @override
  String get totalPlays => 'Parties jouées';

  @override
  String get totalPlayTime => 'Temps de jeu total';

  @override
  String get statsByDifficulty => 'Par difficulté';

  @override
  String get playCount => 'Parties';

  @override
  String get bestTime => 'Meilleur temps';

  @override
  String get averageTime => 'Temps moyen';

  @override
  String timesCount(int count) {
    return '$count fois';
  }

  @override
  String get noData => 'Aucune donnée';

  @override
  String get resetStatsTitle => 'Réinitialiser les statistiques';

  @override
  String get resetStatsMessage =>
      'Réinitialiser toutes les statistiques ?\nCette action est irréversible.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Débloqués : $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Obtenu le : $date';
  }

  @override
  String get achFirstWinTitle => 'Première victoire';

  @override
  String get achFirstWinDesc => 'Terminez le jeu pour la première fois';

  @override
  String get achSpeed10Title => 'Étoile de vitesse';

  @override
  String get achSpeed10Desc => 'Terminez en moins de 10 secondes';

  @override
  String get achSpeed20Title => 'Maître de la vitesse';

  @override
  String get achSpeed20Desc => 'Terminez en moins de 20 secondes';

  @override
  String get achGames10Title => 'Joueur';

  @override
  String get achGames10Desc => 'Jouez 10 parties';

  @override
  String get achGames50Title => 'Vétéran';

  @override
  String get achGames50Desc => 'Jouez 50 parties';

  @override
  String get achGames100Title => 'Légende';

  @override
  String get achGames100Desc => 'Jouez 100 parties';

  @override
  String get achAllModesTitle => 'Polyvalent';

  @override
  String get achAllModesDesc => 'Terminez tous les modes';

  @override
  String get achPerfectDayTitle => 'Journée parfaite';

  @override
  String get achPerfectDayDesc => 'Terminez 10 parties en une journée';

  @override
  String get themeColor => 'Couleur du thème';

  @override
  String get themeBlue => 'Bleu';

  @override
  String get themeGreen => 'Vert';

  @override
  String get themePurple => 'Violet';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeRed => 'Rouge';

  @override
  String get themePink => 'Rose';

  @override
  String get themeTeal => 'Bleu canard';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get sound => 'Son';

  @override
  String get soundSubtitle => 'Effets sonores et vibrations';

  @override
  String get bgm => 'Musique';

  @override
  String get bgmSubtitle => 'Musique du titre et du jeu';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Paramètre du système';

  @override
  String get tutGoalTitle => 'Objectif';

  @override
  String get tutGoalDesc =>
      'Touchez les chiffres dans l\'ordre à partir de 1.\nTouchez-les tous dans le bon ordre pour gagner !';

  @override
  String get tutTimeTitle => 'Contre la montre';

  @override
  String get tutTimeDesc =>
      'Essayez de finir le plus vite possible.\nVotre temps est enregistré à la milliseconde près.';

  @override
  String get tutRankingTitle => 'Classement';

  @override
  String get tutRankingDesc =>
      'Vos 10 meilleurs temps sont enregistrés par difficulté.\nBattez votre record personnel !';

  @override
  String get tutAchievementsTitle => 'Succès';

  @override
  String get tutAchievementsDesc =>
      'Remplissez des objectifs pour débloquer des succès.\nCollectionnez-les tous !';

  @override
  String get tutCustomizeTitle => 'Personnalisation';

  @override
  String get tutCustomizeDesc =>
      'Changez la couleur du thème dans les paramètres.\nJouez avec votre couleur préférée !';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get muteTooltip => 'Couper le son';

  @override
  String get unmuteTooltip => 'Activer le son';
}

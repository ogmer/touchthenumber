// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Elige el modo de juego';

  @override
  String get ranking => 'Clasificación';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get achievements => 'Logros';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get settings => 'Ajustes';

  @override
  String get nextLabel => 'Sig.: ';

  @override
  String timeLabel(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get clearTitle => '¡Completado!';

  @override
  String get newAchievements => '🏆 ¡Nuevos logros!';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get noRecordsYet => 'Aún no hay récords';

  @override
  String resetRankingTitle(String mode) {
    return 'Restablecer clasificación de $mode';
  }

  @override
  String get resetRankingMessage =>
      '¿Restablecer todas las clasificaciones de este modo?\nEsta acción no se puede deshacer.';

  @override
  String get shareRecord => 'Compartir récord';

  @override
  String get copiedToClipboard => 'Récord copiado al portapapeles';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] ¡Hice $time en el modo $mode! (Puesto #$rank)\nToca los números en orden desde el 1 en este juego de agilidad mental. ¡Pruébalo!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Restablecer';

  @override
  String get overallStats => 'Resumen general';

  @override
  String get totalPlays => 'Partidas totales';

  @override
  String get totalPlayTime => 'Tiempo total de juego';

  @override
  String get statsByDifficulty => 'Por dificultad';

  @override
  String get playCount => 'Partidas';

  @override
  String get bestTime => 'Mejor tiempo';

  @override
  String get averageTime => 'Tiempo medio';

  @override
  String timesCount(int count) {
    return '$count veces';
  }

  @override
  String get noData => 'Sin datos';

  @override
  String get resetStatsTitle => 'Restablecer estadísticas';

  @override
  String get resetStatsMessage =>
      '¿Restablecer todas las estadísticas?\nEsta acción no se puede deshacer.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Desbloqueados: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Conseguido: $date';
  }

  @override
  String get achFirstWinTitle => 'Primera victoria';

  @override
  String get achFirstWinDesc => 'Completa el juego por primera vez';

  @override
  String get achSpeed10Title => 'Estrella veloz';

  @override
  String get achSpeed10Desc => 'Completa en menos de 10 segundos';

  @override
  String get achSpeed20Title => 'Maestro de la velocidad';

  @override
  String get achSpeed20Desc => 'Completa en menos de 20 segundos';

  @override
  String get achGames10Title => 'Jugador';

  @override
  String get achGames10Desc => 'Juega 10 partidas';

  @override
  String get achGames50Title => 'Veterano';

  @override
  String get achGames50Desc => 'Juega 50 partidas';

  @override
  String get achGames100Title => 'Leyenda';

  @override
  String get achGames100Desc => 'Juega 100 partidas';

  @override
  String get achAllModesTitle => 'Todoterreno';

  @override
  String get achAllModesDesc => 'Completa todos los modos';

  @override
  String get achPerfectDayTitle => 'Día perfecto';

  @override
  String get achPerfectDayDesc => 'Completa 10 partidas en un día';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themePurple => 'Morado';

  @override
  String get themeOrange => 'Naranja';

  @override
  String get themeRed => 'Rojo';

  @override
  String get themePink => 'Rosa';

  @override
  String get themeTeal => 'Verde azulado';

  @override
  String get themeIndigo => 'Índigo';

  @override
  String get sound => 'Sonido';

  @override
  String get soundSubtitle => 'Efectos de sonido y vibración';

  @override
  String get bgm => 'Música';

  @override
  String get bgmSubtitle => 'Música del título y del juego';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get tutGoalTitle => 'Objetivo';

  @override
  String get tutGoalDesc =>
      'Toca los números en orden empezando por el 1.\n¡Tócalos todos en el orden correcto para ganar!';

  @override
  String get tutTimeTitle => 'Contrarreloj';

  @override
  String get tutTimeDesc =>
      'Intenta completarlo lo más rápido posible.\nTu tiempo se registra al milisegundo.';

  @override
  String get tutRankingTitle => 'Clasificación';

  @override
  String get tutRankingDesc =>
      'Se guardan tus 10 mejores tiempos por dificultad.\n¡Supera tu récord personal!';

  @override
  String get tutAchievementsTitle => 'Logros';

  @override
  String get tutAchievementsDesc =>
      'Cumple objetivos para desbloquear logros.\n¡Consíguelos todos!';

  @override
  String get tutCustomizeTitle => 'Personaliza';

  @override
  String get tutCustomizeDesc =>
      'Cambia el color del tema en Ajustes.\n¡Juega con tu color favorito!';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Listo';

  @override
  String get muteTooltip => 'Silenciar';

  @override
  String get unmuteTooltip => 'Activar sonido';
}

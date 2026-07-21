// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Escolha o modo de jogo';

  @override
  String get difficultyEasy => 'Iniciante';

  @override
  String get difficultyMedium => 'Intermediário';

  @override
  String get difficultyHard => 'Avançado';

  @override
  String get countdownReady => 'Preparados?';

  @override
  String get countdownGo => 'Vai!';

  @override
  String get ranking => 'Classificação';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get achievements => 'Conquistas';

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get settings => 'Configurações';

  @override
  String get nextLabel => 'Próx.: ';

  @override
  String timeLabel(String time) {
    return 'Tempo: $time';
  }

  @override
  String get clearTitle => 'Concluído!';

  @override
  String get newAchievements => '🏆 Novas conquistas!';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String get noRecordsYet => 'Ainda não há recordes';

  @override
  String resetRankingTitle(String mode) {
    return 'Redefinir classificação $mode';
  }

  @override
  String get resetRankingMessage =>
      'Redefinir todas as classificações deste modo?\nEsta ação não pode ser desfeita.';

  @override
  String get shareRecord => 'Compartilhar recorde';

  @override
  String get copiedToClipboard =>
      'Recorde copiado para a área de transferência';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Fiz $time no modo $mode! (Posição nº$rank)\nToque nos números em ordem a partir do 1 neste desafio de raciocínio contra o tempo. Experimente!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Redefinir';

  @override
  String get overallStats => 'Resumo geral';

  @override
  String get totalPlays => 'Partidas totais';

  @override
  String get totalPlayTime => 'Tempo total de jogo';

  @override
  String get statsByDifficulty => 'Por dificuldade';

  @override
  String get playCount => 'Partidas';

  @override
  String get bestTime => 'Melhor tempo';

  @override
  String get averageTime => 'Tempo médio';

  @override
  String timesCount(int count) {
    return '$count vezes';
  }

  @override
  String get noData => 'Sem dados';

  @override
  String get resetStatsTitle => 'Redefinir estatísticas';

  @override
  String get resetStatsMessage =>
      'Redefinir todas as estatísticas?\nEsta ação não pode ser desfeita.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Desbloqueadas: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Conquistado em: $date';
  }

  @override
  String get achFirstWinTitle => 'Primeira vitória';

  @override
  String get achFirstWinDesc => 'Conclua o jogo pela primeira vez';

  @override
  String get achSpeed10Title => 'Estrela veloz';

  @override
  String get achSpeed10Desc => 'Conclua em menos de 10 segundos';

  @override
  String get achSpeed20Title => 'Mestre da velocidade';

  @override
  String get achSpeed20Desc => 'Conclua em menos de 20 segundos';

  @override
  String get achGames10Title => 'Jogador';

  @override
  String get achGames10Desc => 'Jogue 10 partidas';

  @override
  String get achGames50Title => 'Veterano';

  @override
  String get achGames50Desc => 'Jogue 50 partidas';

  @override
  String get achGames100Title => 'Lenda';

  @override
  String get achGames100Desc => 'Jogue 100 partidas';

  @override
  String get achAllModesTitle => 'Versátil';

  @override
  String get achAllModesDesc => 'Conclua todos os modos';

  @override
  String get achPerfectDayTitle => 'Dia perfeito';

  @override
  String get achPerfectDayDesc => 'Conclua 10 partidas em um dia';

  @override
  String get themeColor => 'Cor do tema';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themePurple => 'Roxo';

  @override
  String get themeOrange => 'Laranja';

  @override
  String get themeRed => 'Vermelho';

  @override
  String get themePink => 'Rosa';

  @override
  String get themeTeal => 'Verde-azulado';

  @override
  String get themeIndigo => 'Índigo';

  @override
  String get sound => 'Som';

  @override
  String get soundSubtitle => 'Efeitos sonoros e vibração';

  @override
  String get bgm => 'Música';

  @override
  String get bgmSubtitle => 'Música do título e do jogo';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get tutGoalTitle => 'Objetivo';

  @override
  String get tutGoalDesc =>
      'Toque nos números em ordem começando pelo 1.\nToque em todos na ordem certa para vencer!';

  @override
  String get tutTimeTitle => 'Contra o relógio';

  @override
  String get tutTimeDesc =>
      'Tente concluir o mais rápido possível.\nSeu tempo é registrado em milissegundos.';

  @override
  String get tutRankingTitle => 'Classificação';

  @override
  String get tutRankingDesc =>
      'Seus 10 melhores tempos são salvos por dificuldade.\nSupere seu recorde pessoal!';

  @override
  String get tutAchievementsTitle => 'Conquistas';

  @override
  String get tutAchievementsDesc =>
      'Cumpra objetivos para desbloquear conquistas.\nColecione todas!';

  @override
  String get tutCustomizeTitle => 'Personalize';

  @override
  String get tutCustomizeDesc =>
      'Mude a cor do tema nas configurações.\nJogue com sua cor favorita!';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Avançar';

  @override
  String get done => 'Concluir';

  @override
  String get muteTooltip => 'Silenciar';

  @override
  String get unmuteTooltip => 'Ativar som';
}

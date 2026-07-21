// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Touch the Number';

  @override
  String get selectGameMode => 'Выберите режим игры';

  @override
  String get difficultyEasy => 'Новичок';

  @override
  String get difficultyMedium => 'Средний';

  @override
  String get difficultyHard => 'Продвинутый';

  @override
  String get countdownReady => 'Готовы?';

  @override
  String get countdownGo => 'Старт!';

  @override
  String get ranking => 'Рейтинг';

  @override
  String get statistics => 'Статистика';

  @override
  String get achievements => 'Достижения';

  @override
  String get howToPlay => 'Как играть';

  @override
  String get settings => 'Настройки';

  @override
  String get nextLabel => 'След.: ';

  @override
  String timeLabel(String time) {
    return 'Время: $time';
  }

  @override
  String get clearTitle => 'Готово!';

  @override
  String get newAchievements => '🏆 Новые достижения!';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get backToHome => 'На главную';

  @override
  String get noRecordsYet => 'Пока нет рекордов';

  @override
  String resetRankingTitle(String mode) {
    return 'Сбросить рейтинг $mode';
  }

  @override
  String get resetRankingMessage =>
      'Сбросить все рейтинги этого режима?\nЭто действие нельзя отменить.';

  @override
  String get shareRecord => 'Поделиться рекордом';

  @override
  String get copiedToClipboard => 'Рекорд скопирован в буфер обмена';

  @override
  String shareRecordText(String mode, String time, int rank) {
    return '[Touch the Number] Мой результат $time в режиме $mode! (Место $rank)\nНажимайте числа по порядку с 1 — тренировка мозга на время. Попробуйте!\n#TouchTheNumber';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get reset => 'Сбросить';

  @override
  String get overallStats => 'Общая статистика';

  @override
  String get totalPlays => 'Всего игр';

  @override
  String get totalPlayTime => 'Общее время игры';

  @override
  String get statsByDifficulty => 'По сложности';

  @override
  String get playCount => 'Игры';

  @override
  String get bestTime => 'Лучшее время';

  @override
  String get averageTime => 'Среднее время';

  @override
  String timesCount(int count) {
    return '$count раз';
  }

  @override
  String get noData => 'Нет данных';

  @override
  String get resetStatsTitle => 'Сбросить статистику';

  @override
  String get resetStatsMessage =>
      'Сбросить всю статистику?\nЭто действие нельзя отменить.';

  @override
  String achievementProgress(int unlocked, int total) {
    return 'Открыто: $unlocked/$total';
  }

  @override
  String unlockedAt(String date) {
    return 'Получено: $date';
  }

  @override
  String get achFirstWinTitle => 'Первая победа';

  @override
  String get achFirstWinDesc => 'Пройдите игру в первый раз';

  @override
  String get achSpeed10Title => 'Звезда скорости';

  @override
  String get achSpeed10Desc => 'Пройдите быстрее 10 секунд';

  @override
  String get achSpeed20Title => 'Мастер скорости';

  @override
  String get achSpeed20Desc => 'Пройдите быстрее 20 секунд';

  @override
  String get achGames10Title => 'Игрок';

  @override
  String get achGames10Desc => 'Сыграйте 10 игр';

  @override
  String get achGames50Title => 'Ветеран';

  @override
  String get achGames50Desc => 'Сыграйте 50 игр';

  @override
  String get achGames100Title => 'Легенда';

  @override
  String get achGames100Desc => 'Сыграйте 100 игр';

  @override
  String get achAllModesTitle => 'Универсал';

  @override
  String get achAllModesDesc => 'Пройдите все режимы';

  @override
  String get achPerfectDayTitle => 'Идеальный день';

  @override
  String get achPerfectDayDesc => 'Пройдите 10 игр за один день';

  @override
  String get themeColor => 'Цвет темы';

  @override
  String get themeBlue => 'Синий';

  @override
  String get themeGreen => 'Зелёный';

  @override
  String get themePurple => 'Фиолетовый';

  @override
  String get themeOrange => 'Оранжевый';

  @override
  String get themeRed => 'Красный';

  @override
  String get themePink => 'Розовый';

  @override
  String get themeTeal => 'Бирюзовый';

  @override
  String get themeIndigo => 'Индиго';

  @override
  String get sound => 'Звук';

  @override
  String get soundSubtitle => 'Звуковые эффекты и вибрация';

  @override
  String get bgm => 'Музыка';

  @override
  String get bgmSubtitle => 'Музыка в меню и в игре';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get tutGoalTitle => 'Цель игры';

  @override
  String get tutGoalDesc =>
      'Нажимайте числа по порядку, начиная с 1.\nНажмите все в правильном порядке, чтобы победить!';

  @override
  String get tutTimeTitle => 'Наперегонки со временем';

  @override
  String get tutTimeDesc =>
      'Постарайтесь пройти как можно быстрее.\nВремя фиксируется с точностью до миллисекунды.';

  @override
  String get tutRankingTitle => 'Рейтинг';

  @override
  String get tutRankingDesc =>
      'Для каждой сложности сохраняются 10 лучших результатов.\nПобейте свой личный рекорд!';

  @override
  String get tutAchievementsTitle => 'Достижения';

  @override
  String get tutAchievementsDesc =>
      'Выполняйте условия, чтобы открывать достижения.\nСоберите их все!';

  @override
  String get tutCustomizeTitle => 'Оформление';

  @override
  String get tutCustomizeDesc =>
      'Меняйте цвет темы в настройках.\nИграйте в любимом цвете!';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get done => 'Готово';

  @override
  String get muteTooltip => 'Выключить звук';

  @override
  String get unmuteTooltip => 'Включить звук';
}

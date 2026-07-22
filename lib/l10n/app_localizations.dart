import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Touch the Number'**
  String get appTitle;

  /// No description provided for @selectGameMode.
  ///
  /// In en, this message translates to:
  /// **'Select Game Mode'**
  String get selectGameMode;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyHard;

  /// No description provided for @countdownReady.
  ///
  /// In en, this message translates to:
  /// **'Ready?'**
  String get countdownReady;

  /// No description provided for @countdownGo.
  ///
  /// In en, this message translates to:
  /// **'Go!'**
  String get countdownGo;

  /// No description provided for @newBestRecord.
  ///
  /// In en, this message translates to:
  /// **'New Best!'**
  String get newBestRecord;

  /// No description provided for @behindBest.
  ///
  /// In en, this message translates to:
  /// **'{time} off your best'**
  String behindBest(String time);

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank #{rank}'**
  String rankLabel(int rank);

  /// No description provided for @almostFirst.
  ///
  /// In en, this message translates to:
  /// **'Almost first place!'**
  String get almostFirst;

  /// No description provided for @rankingLocalTab.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get rankingLocalTab;

  /// No description provided for @rankingOnlineTab.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get rankingOnlineTab;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @onlineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Online ranking is unavailable'**
  String get onlineUnavailable;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next: '**
  String get nextLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String timeLabel(String time);

  /// No description provided for @clearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear!'**
  String get clearTitle;

  /// No description provided for @newAchievements.
  ///
  /// In en, this message translates to:
  /// **'🏆 New Achievements!'**
  String get newAchievements;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecordsYet;

  /// No description provided for @resetRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset {mode} Ranking'**
  String resetRankingTitle(String mode);

  /// No description provided for @resetRankingMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset all rankings for this mode?\nThis cannot be undone.'**
  String get resetRankingMessage;

  /// No description provided for @shareRecord.
  ///
  /// In en, this message translates to:
  /// **'Share record'**
  String get shareRecord;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Record copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @shareRecordText.
  ///
  /// In en, this message translates to:
  /// **'[Touch the Number] I scored {time} in {mode} mode! (Rank #{rank})\nTap the numbers from 1 in order in this brain-training time attack. Give it a try!\n#TouchTheNumber'**
  String shareRecordText(String mode, String time, int rank);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @overallStats.
  ///
  /// In en, this message translates to:
  /// **'Overall Stats'**
  String get overallStats;

  /// No description provided for @totalPlays.
  ///
  /// In en, this message translates to:
  /// **'Total Plays'**
  String get totalPlays;

  /// No description provided for @totalPlayTime.
  ///
  /// In en, this message translates to:
  /// **'Total Play Time'**
  String get totalPlayTime;

  /// No description provided for @statsByDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Stats by Difficulty'**
  String get statsByDifficulty;

  /// No description provided for @playCount.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get playCount;

  /// No description provided for @bestTime.
  ///
  /// In en, this message translates to:
  /// **'Best Time'**
  String get bestTime;

  /// No description provided for @averageTime.
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get averageTime;

  /// No description provided for @timesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String timesCount(int count);

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @resetStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Statistics'**
  String get resetStatsTitle;

  /// No description provided for @resetStatsMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset all statistics?\nThis cannot be undone.'**
  String get resetStatsMessage;

  /// No description provided for @achievementProgress.
  ///
  /// In en, this message translates to:
  /// **'Unlocked: {unlocked}/{total}'**
  String achievementProgress(int unlocked, int total);

  /// No description provided for @unlockedAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocked: {date}'**
  String unlockedAt(String date);

  /// No description provided for @achFirstWinTitle.
  ///
  /// In en, this message translates to:
  /// **'First Victory'**
  String get achFirstWinTitle;

  /// No description provided for @achFirstWinDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear the game for the first time'**
  String get achFirstWinDesc;

  /// No description provided for @achSpeed10Title.
  ///
  /// In en, this message translates to:
  /// **'Speed Star'**
  String get achSpeed10Title;

  /// No description provided for @achSpeed10Desc.
  ///
  /// In en, this message translates to:
  /// **'Clear within 10 seconds'**
  String get achSpeed10Desc;

  /// No description provided for @achSpeed20Title.
  ///
  /// In en, this message translates to:
  /// **'Speed Master'**
  String get achSpeed20Title;

  /// No description provided for @achSpeed20Desc.
  ///
  /// In en, this message translates to:
  /// **'Clear within 20 seconds'**
  String get achSpeed20Desc;

  /// No description provided for @achGames10Title.
  ///
  /// In en, this message translates to:
  /// **'Gamer'**
  String get achGames10Title;

  /// No description provided for @achGames10Desc.
  ///
  /// In en, this message translates to:
  /// **'Play 10 times'**
  String get achGames10Desc;

  /// No description provided for @achGames50Title.
  ///
  /// In en, this message translates to:
  /// **'Veteran'**
  String get achGames50Title;

  /// No description provided for @achGames50Desc.
  ///
  /// In en, this message translates to:
  /// **'Play 50 times'**
  String get achGames50Desc;

  /// No description provided for @achGames100Title.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get achGames100Title;

  /// No description provided for @achGames100Desc.
  ///
  /// In en, this message translates to:
  /// **'Play 100 times'**
  String get achGames100Desc;

  /// No description provided for @achAllModesTitle.
  ///
  /// In en, this message translates to:
  /// **'All-Rounder'**
  String get achAllModesTitle;

  /// No description provided for @achAllModesDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear every mode'**
  String get achAllModesDesc;

  /// No description provided for @achPerfectDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect Day'**
  String get achPerfectDayTitle;

  /// No description provided for @achPerfectDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear 10 times in one day'**
  String get achPerfectDayDesc;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themeOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeOrange;

  /// No description provided for @themeRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeRed;

  /// No description provided for @themePink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get themePink;

  /// No description provided for @themeTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeTeal;

  /// No description provided for @themeIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeIndigo;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @soundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound effects and vibration'**
  String get soundSubtitle;

  /// No description provided for @bgm.
  ///
  /// In en, this message translates to:
  /// **'BGM'**
  String get bgm;

  /// No description provided for @bgmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Title and in-game music'**
  String get bgmSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @tutGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get tutGoalTitle;

  /// No description provided for @tutGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the numbers in order, starting from 1.\nTap them all in the correct order to clear the board!'**
  String get tutGoalDesc;

  /// No description provided for @tutTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Race the Clock'**
  String get tutTimeTitle;

  /// No description provided for @tutTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Aim to clear as fast as you can.\nYour time is recorded down to the millisecond.'**
  String get tutTimeDesc;

  /// No description provided for @tutRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get tutRankingTitle;

  /// No description provided for @tutRankingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your top 10 times are saved for each difficulty.\nKeep challenging your personal best!'**
  String get tutRankingDesc;

  /// No description provided for @tutAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get tutAchievementsTitle;

  /// No description provided for @tutAchievementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete specific goals to unlock achievements.\nCollect them all!'**
  String get tutAchievementsDesc;

  /// No description provided for @tutCustomizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get tutCustomizeTitle;

  /// No description provided for @tutCustomizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Change the theme color in Settings.\nPlay in your favorite color!'**
  String get tutCustomizeDesc;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @muteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mute sounds'**
  String get muteTooltip;

  /// No description provided for @unmuteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unmute sounds'**
  String get unmuteTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

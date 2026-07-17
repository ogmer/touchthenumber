import '../models/achievement.dart';
import '../models/app_theme.dart';
import 'app_localizations.dart';

/// enumの表示名をロケールに応じて解決する

extension AchievementTypeL10n on AchievementType {
  String title(AppLocalizations l10n) => switch (this) {
        AchievementType.firstWin => l10n.achFirstWinTitle,
        AchievementType.speed10 => l10n.achSpeed10Title,
        AchievementType.speed20 => l10n.achSpeed20Title,
        AchievementType.games10 => l10n.achGames10Title,
        AchievementType.games50 => l10n.achGames50Title,
        AchievementType.games100 => l10n.achGames100Title,
        AchievementType.allModes => l10n.achAllModesTitle,
        AchievementType.perfectDay => l10n.achPerfectDayTitle,
      };

  String description(AppLocalizations l10n) => switch (this) {
        AchievementType.firstWin => l10n.achFirstWinDesc,
        AchievementType.speed10 => l10n.achSpeed10Desc,
        AchievementType.speed20 => l10n.achSpeed20Desc,
        AchievementType.games10 => l10n.achGames10Desc,
        AchievementType.games50 => l10n.achGames50Desc,
        AchievementType.games100 => l10n.achGames100Desc,
        AchievementType.allModes => l10n.achAllModesDesc,
        AchievementType.perfectDay => l10n.achPerfectDayDesc,
      };
}

extension AppThemeL10n on AppTheme {
  String displayName(AppLocalizations l10n) => switch (this) {
        AppTheme.blue => l10n.themeBlue,
        AppTheme.green => l10n.themeGreen,
        AppTheme.purple => l10n.themePurple,
        AppTheme.orange => l10n.themeOrange,
        AppTheme.red => l10n.themeRed,
        AppTheme.pink => l10n.themePink,
        AppTheme.teal => l10n.themeTeal,
        AppTheme.indigo => l10n.themeIndigo,
      };
}

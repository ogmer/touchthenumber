import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';

class SettingsService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _bgmEnabledKey = 'bgm_enabled';
  static const String _themeKey = 'app_theme';
  static const String _localeKey = 'locale_code';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  bool get isSoundEnabled => _prefs.getBool(_soundEnabledKey) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  bool get isBgmEnabled => _prefs.getBool(_bgmEnabledKey) ?? true;

  Future<void> setBgmEnabled(bool enabled) async {
    await _prefs.setBool(_bgmEnabledKey, enabled);
  }

  AppTheme get theme {
    final themeName = _prefs.getString(_themeKey);
    if (themeName == null) return AppTheme.blue;
    try {
      return AppTheme.values.byName(themeName);
    } catch (e) {
      return AppTheme.blue;
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    await _prefs.setString(_themeKey, theme.name);
  }

  /// 言語コード（'ja'/'en'）。nullはシステム設定に従う
  String? get localeCode => _prefs.getString(_localeKey);

  Future<void> setLocaleCode(String? code) async {
    if (code == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, code);
    }
  }
}

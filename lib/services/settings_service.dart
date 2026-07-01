import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';

class SettingsService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _themeKey = 'app_theme';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isSoundEnabled => _prefs.getBool(_soundEnabledKey) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
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
}

import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';

class SettingsService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _bgmEnabledKey = 'bgm_enabled';
  static const String _soundVolumeKey = 'sound_volume';
  static const String _bgmVolumeKey = 'bgm_volume';
  static const String _themeKey = 'app_theme';
  static const String _localeKey = 'locale_code';
  static const String _playerNameKey = 'player_name';

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

  /// 効果音の音量（0.0～1.0）。デフォルトは1.0（最大）
  double get soundVolume => _prefs.getDouble(_soundVolumeKey) ?? 1.0;

  Future<void> setSoundVolume(double volume) async {
    await _prefs.setDouble(_soundVolumeKey, volume.clamp(0.0, 1.0));
  }

  /// BGMの音量（0.0～1.0）。デフォルトは0.4
  double get bgmVolume => _prefs.getDouble(_bgmVolumeKey) ?? 0.4;

  Future<void> setBgmVolume(double volume) async {
    await _prefs.setDouble(_bgmVolumeKey, volume.clamp(0.0, 1.0));
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

  /// オンラインランキングに表示するニックネーム（未設定は空文字）
  String get playerName => _prefs.getString(_playerNameKey) ?? '';

  Future<void> setPlayerName(String name) async {
    await _prefs.setString(_playerNameKey, name.trim());
  }
}

import 'package:flutter/services.dart';
import 'settings_service.dart';

class AudioService {
  final SettingsService _settingsService;

  AudioService(this._settingsService);

  Future<void> playCorrectSound() async {
    if (_settingsService.isSoundEnabled) {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.lightImpact();
    }
  }

  Future<void> playErrorSound() async {
    if (_settingsService.isSoundEnabled) {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    }
  }

  Future<void> playCompleteSound() async {
    if (_settingsService.isSoundEnabled) {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.mediumImpact();
    }
  }
}

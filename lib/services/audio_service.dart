import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'settings_service.dart';

class AudioService {
  final SettingsService _settingsService;

  // 音の種類ごとにプレイヤーを分け、連打時に別の音が途切れないようにする
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  final AudioPlayer _completePlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  AudioService(this._settingsService) {
    for (final player in [_correctPlayer, _errorPlayer, _completePlayer]) {
      player.setReleaseMode(ReleaseMode.stop);
    }
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> _play(AudioPlayer player, String assetPath) async {
    try {
      await player.stop();
      await player.play(AssetSource(assetPath));
    } catch (e) {
      // 音声デバイスが使えない環境では無音で続行する
    }
  }

  Future<void> playCorrectSound() async {
    if (!_settingsService.isSoundEnabled) return;
    await _play(_correctPlayer, 'sounds/correct.wav');
    await HapticFeedback.lightImpact();
  }

  Future<void> playErrorSound() async {
    if (!_settingsService.isSoundEnabled) return;
    await _play(_errorPlayer, 'sounds/error.wav');
    await HapticFeedback.heavyImpact();
  }

  Future<void> playCompleteSound() async {
    if (!_settingsService.isSoundEnabled) return;
    await _play(_completePlayer, 'sounds/complete.wav');
    await HapticFeedback.mediumImpact();
  }

  /// プレイ中BGM（アップテンポ）
  Future<void> startGameBgm() =>
      _startBgm('sounds/bgm.wav', volume: 0.4);

  /// タイトル・メニューBGM（落ち着いた曲調）
  Future<void> startTitleBgm() =>
      _startBgm('sounds/bgm_title.wav', volume: 0.35);

  Future<void> _startBgm(String assetPath, {required double volume}) async {
    if (!_settingsService.isBgmEnabled) return;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setVolume(volume);
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // 音声デバイスが使えない環境では無音で続行する
    }
  }

  /// BGMが再生中かどうか（Webのオートプレイ制限で開始に失敗した場合の再試行判定用）
  bool get isBgmPlaying => _bgmPlayer.state == PlayerState.playing;

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      // 停止失敗は無視する
    }
  }

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _errorPlayer.dispose();
    await _completePlayer.dispose();
    await _bgmPlayer.dispose();
  }
}

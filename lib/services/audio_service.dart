import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'settings_service.dart';

class AudioService {
  final SettingsService _settingsService;

  // 音の種類ごとにプレイヤーを分け、連打時に別の音が途切れないようにする
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  final AudioPlayer _completePlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  // 初期化完了を待つためのFuture
  late final Future<void> _initializationComplete;

  AudioService(this._settingsService) {
    for (final player in [_correctPlayer, _errorPlayer, _completePlayer]) {
      player.setReleaseMode(ReleaseMode.stop);
    }
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _initializationComplete = _init();
  }

  Future<void> _init() async {
    // オーディオコンテキストの設定を先に済ませてから音源を読み込む
    await _configureAudioContext();
    await _preloadAssets();
  }

  /// 効果音（正解・ミス・クリア）を鳴らすたびにBGMが止まる問題への対策。
  /// 既定(focus: gain)では各プレイヤーが再生時にオーディオフォーカスを奪い合い、
  /// 効果音プレイヤーがフォーカスを取るとBGMプレイヤーが停止させられてしまう。
  /// mixWithOthers にすると Android はフォーカス要求をせず、iOS は他とミックスするため、
  /// アプリ内の効果音とBGMが共存できる。
  /// グローバル設定だけでは「生成済みの各プレイヤー」に反映されないため、
  /// 全プレイヤーへ個別にも適用する。
  Future<void> _configureAudioContext() async {
    final context = AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build();
    try {
      await AudioPlayer.global.setAudioContext(context);
      for (final player in [
        _correctPlayer,
        _errorPlayer,
        _completePlayer,
        _bgmPlayer,
      ]) {
        await player.setAudioContext(context);
      }
    } catch (e) {
      // 設定に対応しない環境では既定のまま続行する
    }
  }

  Future<void> _preloadAssets() async {
    try {
      await AudioCache.instance.loadAll(const [
        'sounds/correct.wav',
        'sounds/error.wav',
        'sounds/complete.wav',
        // BGMはサイズ削減のためMP3圧縮している（効果音は短いのでWAVのまま）
        'sounds/bgm.mp3',
        'sounds/bgm_title.mp3',
      ]);
    } catch (e) {
      // プリロード失敗時も、再生時に通常どおり読み込まれるので無視してよい
    }
  }

  Future<void> _play(AudioPlayer player, String assetPath,
      {double? volume}) async {
    // 初期化が完了するまで待つ（起動時の音の途切れを防ぐ）
    await _initializationComplete;

    try {
      await player.stop();
      await player.play(AssetSource(assetPath),
          volume: volume ?? _settingsService.soundVolume);
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

  // ミュート解除時に「直前に流していたBGM」を再開するために覚えておく
  String? _lastBgmAsset;

  /// プレイ中BGM（アップテンポ）
  Future<void> startGameBgm() => _startBgm('sounds/bgm.mp3');

  /// タイトル・メニューBGM（落ち着いた曲調）
  Future<void> startTitleBgm() => _startBgm('sounds/bgm_title.mp3');

  Future<void> _startBgm(String assetPath) async {
    // 初期化が完了するまで待つ（起動時の音の途切れを防ぐ）
    await _initializationComplete;

    // BGMがオフでも「次にどの曲を流すべきか」は記録しておく
    _lastBgmAsset = assetPath;
    if (!_settingsService.isBgmEnabled) return;
    try {
      // BGMを確実にループさせるため、再生前にループモードを設定する
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      // play()はsetSource→resumeをまとめて行い、既存の曲があれば切り替える。
      // stop/setVolumeを個別にawaitするとWebでトラック切り替えに失敗する
      // ことがあるため、音量指定ごと1回のplay()で開始する
      await _bgmPlayer.play(AssetSource(assetPath),
          volume: _settingsService.bgmVolume);
    } catch (e) {
      // 音声デバイスが使えない環境では無音で続行する
      debugPrint('BGM再生に失敗: $assetPath / $e');
    }
  }

  /// ミュート解除時などに、直前に流していたBGMを再開する
  Future<void> resumeBgm() async {
    final asset = _lastBgmAsset;
    if (asset == null) return;
    await _startBgm(asset);
  }

  /// BGMの音量を変更する（再生中の曲に即座に反映）
  Future<void> updateBgmVolume(double volume) async {
    try {
      await _bgmPlayer.setVolume(volume);
    } catch (e) {
      // 音量変更失敗は無視する
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

  /// アプリがバックグラウンドに回った時にBGMを一時停止する
  /// （バックグラウンド再生を防ぎ、位置は保持して復帰時に再開できるようにする）
  Future<void> pauseBgmForBackground() async {
    if (!isBgmPlaying) return;
    try {
      await _bgmPlayer.pause();
    } catch (e) {
      // 一時停止失敗は無視する
    }
  }

  /// アプリがフォアグラウンドに戻った時、バックグラウンドで一時停止していたBGMを再開する
  Future<void> resumeBgmFromBackground() async {
    if (!_settingsService.isBgmEnabled) return;
    if (_bgmPlayer.state != PlayerState.paused) return;
    try {
      await _bgmPlayer.resume();
    } catch (e) {
      // 再開失敗は無視する
    }
  }

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _errorPlayer.dispose();
    await _completePlayer.dispose();
    await _bgmPlayer.dispose();
  }
}

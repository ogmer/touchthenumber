import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';

/// 効果音とBGMをまとめて切り替えるAppBar用のマスターミュートボタン。
/// 設定画面の「サウンド」「BGM」スイッチとも状態が同期する
class SoundToggleButton extends ConsumerWidget {
  const SoundToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundOn = ref.watch(soundEnabledProvider);
    final bgmOn = ref.watch(bgmEnabledProvider);
    // 両方オフのときだけ「ミュート中」とみなす
    final muted = !soundOn && !bgmOn;

    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
      tooltip: muted ? l10n.unmuteTooltip : l10n.muteTooltip,
      onPressed: () => _toggleAll(ref, enable: muted),
    );
  }

  Future<void> _toggleAll(WidgetRef ref, {required bool enable}) async {
    await ref.read(soundEnabledProvider.notifier).set(enable);
    await ref.read(bgmEnabledProvider.notifier).set(enable);

    final audio = ref.read(audioServiceProvider);
    if (enable) {
      await audio.resumeBgm();
    } else {
      await audio.stopBgm();
    }
  }
}

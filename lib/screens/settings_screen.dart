import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_theme.dart';
import '../providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);
    final soundOn = ref.watch(soundEnabledProvider);
    final bgmOn = ref.watch(bgmEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'テーマカラー',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...AppTheme.values.map((theme) {
            final isSelected = currentTheme == theme;
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3)
                      : null,
                ),
              ),
              title: Text(theme.displayName),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => ref.read(themeProvider.notifier).setTheme(theme),
            );
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('サウンド'),
            subtitle: const Text('効果音とバイブレーション'),
            secondary: Icon(soundOn ? Icons.volume_up : Icons.volume_off),
            value: soundOn,
            onChanged: (value) =>
                ref.read(soundEnabledProvider.notifier).set(value),
          ),
          SwitchListTile(
            title: const Text('BGM'),
            subtitle: const Text('タイトル・プレイ中の音楽'),
            secondary: Icon(bgmOn ? Icons.music_note : Icons.music_off),
            value: bgmOn,
            onChanged: (value) async {
              await ref.read(bgmEnabledProvider.notifier).set(value);
              // 切り替えを即時反映する（この画面はメニュー階層なのでタイトル曲）
              final audio = ref.read(audioServiceProvider);
              if (value) {
                audio.startTitleBgm();
              } else {
                await audio.stopBgm();
              }
            },
          ),
        ],
      ),
    );
  }
}

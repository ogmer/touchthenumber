import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../l10n/enum_translations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeProvider);
    final soundOn = ref.watch(soundEnabledProvider);
    final bgmOn = ref.watch(bgmEnabledProvider);
    final localeCode = ref.watch(localeProvider)?.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.themeColor,
              style: const TextStyle(
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
              title: Text(theme.displayName(l10n)),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => ref.read(themeProvider.notifier).setTheme(theme),
            );
          }),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.sound),
            subtitle: Text(l10n.soundSubtitle),
            secondary: Icon(soundOn ? Icons.volume_up : Icons.volume_off),
            value: soundOn,
            onChanged: (value) =>
                ref.read(soundEnabledProvider.notifier).set(value),
          ),
          SwitchListTile(
            title: Text(l10n.bgm),
            subtitle: Text(l10n.bgmSubtitle),
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
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 言語名は各言語の自称で表示する（多言語アプリの慣例）
          ...[
            (code: null, label: l10n.languageSystem),
            (code: 'ja', label: '日本語'),
            (code: 'en', label: 'English'),
            (code: 'zh', label: '简体中文'),
            (code: 'ko', label: '한국어'),
            (code: 'es', label: 'Español'),
            (code: 'fr', label: 'Français'),
          ].map(
            (option) => _buildLanguageTile(
              label: option.label,
              code: option.code,
              selectedCode: localeCode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required String label,
    required String? code,
    required String? selectedCode,
  }) {
    final isSelected = code == selectedCode;
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () => ref.read(localeProvider.notifier).set(code),
    );
  }
}

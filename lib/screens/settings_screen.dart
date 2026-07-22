import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import '../providers.dart';
import '../widgets/neumorphic.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // 言語名は各言語の自称で表示する（多言語アプリの慣例）。
  // 「システムの言語に従う」はローカライズが必要なため build() 側で先頭に追加する
  static const _languageOptions = [
    (code: 'ja', label: '日本語'),
    (code: 'en', label: 'English'),
    (code: 'zh', label: '简体中文'),
    (code: 'zh_Hant', label: '繁體中文'),
    (code: 'ko', label: '한국어'),
    (code: 'es', label: 'Español'),
    (code: 'fr', label: 'Français'),
    (code: 'de', label: 'Deutsch'),
    (code: 'it', label: 'Italiano'),
    (code: 'pt', label: 'Português'),
    (code: 'ru', label: 'Русский'),
    (code: 'ar', label: 'العربية'),
    (code: 'hi', label: 'हिन्दी'),
    (code: 'id', label: 'Bahasa Indonesia'),
    (code: 'th', label: 'ไทย'),
    (code: 'vi', label: 'Tiếng Việt'),
  ];

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(playerNameProvider));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeProvider);
    final soundOn = ref.watch(soundEnabledProvider);
    final bgmOn = ref.watch(bgmEnabledProvider);
    final soundVolume = ref.watch(soundVolumeProvider);
    final bgmVolume = ref.watch(bgmVolumeProvider);
    final localeCode = codeFromLocale(ref.watch(localeProvider));
    final onlineEnabled = ref.watch(onlineEnabledProvider);

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: AppTheme.values.map((theme) {
                final isSelected = currentTheme == theme;
                return GestureDetector(
                  onTap: () =>
                      ref.read(themeProvider.notifier).setTheme(theme),
                  child: NeumorphicContainer(
                    shape: BoxShape.circle,
                    style: isSelected
                        ? NeumorphicStyle.pressed
                        : NeumorphicStyle.raised,
                    depth: 5,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Center(
                        child: NeumorphicContainer(
                          shape: BoxShape.circle,
                          depth: 3,
                          color: theme.color,
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 20)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          _buildSwitchTileWithVolume(
            title: l10n.sound,
            subtitle: l10n.soundSubtitle,
            icon: soundOn ? Icons.volume_up : Icons.volume_off,
            value: soundOn,
            onChanged: (value) =>
                ref.read(soundEnabledProvider.notifier).set(value),
            volume: soundVolume,
            onVolumeChanged: (value) =>
                ref.read(soundVolumeProvider.notifier).set(value),
          ),
          _buildSwitchTileWithVolume(
            title: l10n.bgm,
            subtitle: l10n.bgmSubtitle,
            icon: bgmOn ? Icons.music_note : Icons.music_off,
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
            volume: bgmVolume,
            onVolumeChanged: (value) =>
                ref.read(bgmVolumeProvider.notifier).set(value),
          ),
          const Divider(),
          // オンラインランキング用のニックネーム（Supabase設定時のみ表示）
          if (onlineEnabled) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.nickname,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: NeumorphicContainer(
                style: NeumorphicStyle.pressed,
                borderRadius: 16,
                depth: 5,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _nameController,
                  maxLength: 20,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: l10n.nickname,
                  ),
                  onChanged: (value) =>
                      ref.read(playerNameProvider.notifier).set(value),
                ),
              ),
            ),
            const Divider(),
          ],
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: NeumorphicContainer(
              style: NeumorphicStyle.pressed,
              borderRadius: 16,
              depth: 5,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: localeCode,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.languageSystem),
                    ),
                    ..._languageOptions.map(
                      (option) => DropdownMenuItem<String?>(
                        value: option.code,
                        child: Text(option.label),
                      ),
                    ),
                  ],
                  onChanged: (code) =>
                      ref.read(localeProvider.notifier).set(code),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// サウンド/BGMのオンオフと音量調整スライダーを統合したタイル
  Widget _buildSwitchTileWithVolume({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double volume,
    required ValueChanged<double> onVolumeChanged,
  }) {
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: NeumorphicContainer(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: accent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (value) ...[
              Icon(Icons.volume_down, color: accent, size: 20),
              SizedBox(
                width: 150,
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: '${(volume * 100).round()}%',
                ),
              ),
              Icon(Icons.volume_up, color: accent, size: 20),
              const SizedBox(width: 8),
            ],
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

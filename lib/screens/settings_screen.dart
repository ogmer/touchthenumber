import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final VoidCallback onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
            final isSelected = widget.settingsService.theme == theme;
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
              onTap: () async {
                await widget.settingsService.setTheme(theme);
                setState(() {});
                widget.onThemeChanged();
              },
            );
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('サウンド'),
            subtitle: const Text('効果音とバイブレーション'),
            secondary: Icon(
              widget.settingsService.isSoundEnabled
                  ? Icons.volume_up
                  : Icons.volume_off,
            ),
            value: widget.settingsService.isSoundEnabled,
            onChanged: (value) async {
              await widget.settingsService.setSoundEnabled(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

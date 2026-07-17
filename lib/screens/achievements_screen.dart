import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../l10n/enum_translations.dart';
import '../models/achievement.dart';
import '../providers.dart';
import '../utils/formatting.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() =>
      _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  List<Achievement> unlockedAchievements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      isLoading = true;
    });

    final achievements =
        await ref.read(achievementServiceProvider).getAchievements();

    setState(() {
      unlockedAchievements = achievements;
      isLoading = false;
    });
  }

  bool _isUnlocked(AchievementType type) {
    return unlockedAchievements.any((a) => a.type == type);
  }

  Achievement? _getAchievement(AchievementType type) {
    try {
      return unlockedAchievements.firstWhere((a) => a.type == type);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.achievements),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.achievementProgress(
                    unlockedAchievements.length,
                    AchievementType.values.length,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ...AchievementType.values.map(
                  (type) => _buildAchievementCard(l10n, type),
                ),
              ],
            ),
    );
  }

  Widget _buildAchievementCard(AppLocalizations l10n, AchievementType type) {
    final isUnlocked = _isUnlocked(type);
    final achievement = _getAchievement(type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnlocked ? 4 : 1,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.amber : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            type.icon,
            color: isUnlocked ? Colors.white : Colors.grey[600],
            size: 28,
          ),
        ),
        title: Text(
          type.title(l10n),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type.description(l10n),
              style: TextStyle(
                color: isUnlocked ? Colors.black87 : Colors.grey,
              ),
            ),
            if (isUnlocked && achievement != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.unlockedAt(formatDate(achievement.unlockedAt)),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        trailing: isUnlocked
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.lock_outline, color: Colors.grey),
      ),
    );
  }

}

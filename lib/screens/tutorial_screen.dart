import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/neumorphic.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  List<TutorialPage> _buildPages(AppLocalizations l10n) => [
        TutorialPage(
          icon: Icons.touch_app,
          title: l10n.tutGoalTitle,
          description: l10n.tutGoalDesc,
        ),
        TutorialPage(
          icon: Icons.timer,
          title: l10n.tutTimeTitle,
          description: l10n.tutTimeDesc,
        ),
        TutorialPage(
          icon: Icons.emoji_events,
          title: l10n.tutRankingTitle,
          description: l10n.tutRankingDesc,
        ),
        TutorialPage(
          icon: Icons.military_tech,
          title: l10n.tutAchievementsTitle,
          description: l10n.tutAchievementsDesc,
        ),
        TutorialPage(
          icon: Icons.palette,
          title: l10n.tutCustomizeTitle,
          description: l10n.tutCustomizeDesc,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _buildPages(l10n);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.howToPlay),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return _buildPage(pages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(l10n.back),
                  )
                else
                  const SizedBox(width: 80),
                Row(
                  children: List.generate(
                    pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                if (currentPage < pages.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(l10n.next),
                  )
                else
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.done),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicContainer(
            shape: BoxShape.circle,
            depth: 8,
            child: SizedBox(
              width: 160,
              height: 160,
              child: Icon(
                page.icon,
                size: 90,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TutorialPage {
  final IconData icon;
  final String title;
  final String description;

  const TutorialPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

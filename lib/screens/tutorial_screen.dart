import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<TutorialPage> pages = const [
    TutorialPage(
      icon: Icons.touch_app,
      title: 'ゲームの目的',
      description: '1から順番に数字をタップしていきます。\nすべての数字を正しい順番でタップすればクリアです！',
    ),
    TutorialPage(
      icon: Icons.timer,
      title: 'タイムを競おう',
      description: 'できるだけ早くクリアすることを目指しましょう。\nタイムはミリ秒単位で記録されます。',
    ),
    TutorialPage(
      icon: Icons.emoji_events,
      title: 'ランキング',
      description: '各難易度のベスト10タイムが記録されます。\n自己ベストを目指して何度も挑戦しましょう！',
    ),
    TutorialPage(
      icon: Icons.military_tech,
      title: 'アチーブメント',
      description: '特定の条件を達成するとアチーブメントが解除されます。\nすべてのアチーブメントを集めましょう！',
    ),
    TutorialPage(
      icon: Icons.palette,
      title: 'カスタマイズ',
      description: '設定画面からテーマカラーを変更できます。\nお好みの色でプレイしましょう！',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遊び方'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
                    child: const Text('戻る'),
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
                    child: const Text('次へ'),
                  )
                else
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完了'),
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
          Icon(
            page.icon,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
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

import 'package:flutter/material.dart';

import 'template_flow.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color _backgroundTop = Color(0xFFFFFFFF);
  static const Color _backgroundBottom = Color(0xFFFCF9F4);
  static const Color _primary = Color(0xFF7A1824);
  static const Color _cardLight = Color(0xFFF4E4D8);
  static const Color _cardLighter = Color(0xFFFBEFE6);
  static const Color _surface = Color(0xFFFFFBF7);
  static const List<_CommunityPost> _communityPosts = [
    _CommunityPost(
      author: 'Maria J.',
      memorial: 'Remembering Elena',
      message:
          'Shared a photo from her garden and a note about Sunday family dinners.',
      timeAgo: '2h ago',
      hearts: 14,
    ),
    _CommunityPost(
      author: 'Devon L.',
      memorial: 'In Honor of Marcus',
      message: 'Added a voice note and updated the tribute timeline.',
      timeAgo: '5h ago',
      hearts: 9,
    ),
    _CommunityPost(
      author: 'Tara & Kim',
      memorial: 'For Nana Rose',
      message: 'Posted three memories from her handwritten recipe book.',
      timeAgo: '1d ago',
      hearts: 27,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundTop,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_backgroundTop, _backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/splash_logo2.png',
                      height: 172,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Transform.translate(
                    offset: const Offset(0, -6),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a Tribute',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: _primary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Start by Browsing our templates below:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A6253),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  _HomeCard(
                    title: 'Browse Templates',
                    subtitle: 'Pick a thoughtful starting layout',
                    bgColor: _cardLight,
                    imagePath: 'assets/flowers.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TemplateBrowserPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _HomeCard(
                    title: 'My Memories',
                    subtitle: 'Continue writing and updating tributes',
                    bgColor: _cardLighter,
                    imagePath: 'assets/candle.png',
                  ),
                  const SizedBox(height: 14),
                  const _VintageDivider(),
                  const SizedBox(height: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Wall',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Recent updates from shared tributes.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF7A6253)),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _primary.withValues(alpha: 0.26),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(
                        _communityPosts.length,
                        (index) => _CommunityPostTile(
                          post: _communityPosts[index],
                          showDivider: index != _communityPosts.length - 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: _primary,
          unselectedItemColor: const Color(0xFF8D8078),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _primary,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: _NavActiveIcon(icon: Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_rounded),
              activeIcon: _NavActiveIcon(
                icon: Icons.notifications_active_rounded,
              ),
              label: 'Reminders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: _NavActiveIcon(icon: Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              activeIcon: _NavActiveIcon(icon: Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavActiveIcon extends StatelessWidget {
  const _NavActiveIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: HomePage._primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}

class _VintageDivider extends StatelessWidget {
  const _VintageDivider();

  static const Color _line = Color(0xFFC9A98E);
  static const Color _accent = HomePage._primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _OrnateLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.diamond_rounded,
                size: 12,
                color: _accent.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.auto_awesome_rounded, size: 15, color: _accent),
              const SizedBox(width: 4),
              Icon(
                Icons.diamond_rounded,
                size: 12,
                color: _accent.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        const Expanded(child: _OrnateLine()),
      ],
    );
  }
}

class _OrnateLine extends StatelessWidget {
  const _OrnateLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 1.2,
            color: _VintageDivider._line.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 2,
          child: Container(
            height: 1.2,
            color: _VintageDivider._line.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _CommunityPostTile extends StatelessWidget {
  const _CommunityPostTile({required this.post, required this.showDivider});

  final _CommunityPost post;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final String initial = post.author.isNotEmpty
        ? post.author.substring(0, 1).toUpperCase()
        : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E0D2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: HomePage._primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.author,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5B4033),
                            ),
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9E8577),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.memorial,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HomePage._primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.message,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF7A6253),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFB94A5B),
                    size: 15,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${post.hearts}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B6C5F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Divider(
                color: const Color(0xFFE7D8CC).withValues(alpha: 0.9),
                height: 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _CommunityPost {
  const _CommunityPost({
    required this.author,
    required this.memorial,
    required this.message,
    required this.timeAgo,
    required this.hearts,
  });

  final String author;
  final String memorial;
  final String message;
  final String timeAgo;
  final int hearts;
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.bgColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final Color bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 126,
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: HomePage._primary.withValues(alpha: 0.3),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5C4235),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8D7568),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

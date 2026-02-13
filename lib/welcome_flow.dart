import 'package:flutter/material.dart';

import 'home_page.dart';

class WelcomeFlow extends StatefulWidget {
  const WelcomeFlow({super.key});

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  static const Color _background = Color(0xFFF8F0E6);
  static const Color _primary = Color(0xFF7A1824);

  final List<_WelcomePageData> _pages = const [
    _WelcomePageData(
      icon: Icons.favorite_outline_rounded,
      title: 'Welcome to SoulNotes',
      description:
          'A gentle place to honor loved ones, keep their stories alive, and revisit meaningful moments.',
    ),
    _WelcomePageData(
      icon: Icons.auto_stories_outlined,
      title: 'Create Thoughtful Tributes',
      description:
          'Build tributes with words, photos, and memories that celebrate life with warmth and intention.',
    ),
    _WelcomePageData(
      icon: Icons.groups_2_outlined,
      title: 'Share and Remember Together',
      description:
          'Invite family and friends to contribute memories and grow a living collection of remembrance.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Future<void> _onContinue() async {
    final bool isLast = _currentIndex == _pages.length - 1;
    if (isLast) {
      _goToHome();
      return;
    }

    await _controller.animateToPage(
      _currentIndex + 1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/splash_logo2.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _WelcomeCard(page: page);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? _primary
                          : _primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    onPressed: isLast ? null : _goToHome,
                    style: TextButton.styleFrom(
                      foregroundColor: _primary,
                      disabledForegroundColor: Colors.transparent,
                    ),
                    child: Text(isLast ? '' : 'Skip'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(isLast ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.page});

  final _WelcomePageData page;

  static const Color _primary = Color(0xFF7A1824);
  static const Color _card = Color(0xFFF4E4D8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              color: _primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: _primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.45,
              color: Color(0xFF5C4A3E),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomePageData {
  const _WelcomePageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

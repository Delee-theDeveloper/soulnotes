import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color _background = const Color(0xFFF8F0E6); // soft cream
  final Color _primary = const Color(0xFF7A1824); // deep wine
  final Color _cardLight = const Color(0xFFF4E4D8);
  final Color _cardLighter = const Color(0xFFF9EFE7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ===== Top Title =====
            Column(
              children: const [
                Text(
                  'THE',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'REMEMBERING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A1824),
                  ),
                ),
                Text(
                  'APP',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                    color: Color(0xFF7A1824),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ===== Main Content =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Big maroon button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Go to create tribute screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Create a Tribute',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Browse Templates card
                    _HomeCard(
                      title: 'Browse\nTemplates',
                      bgColor: _cardLight,
                      imagePath: 'assets/flowers.png',
                    ),

                    const SizedBox(height: 16),

                    // My Memories card
                    _HomeCard(
                      title: 'My\nMemories',
                      bgColor: _cardLighter,
                      imagePath: 'assets/candle.png',
                    ),

                    const SizedBox(height: 24),

                    // Community Wall text
                    const Text(
                      'Community Wall',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7A1824),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== Bottom Nav =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: _primary,
        unselectedItemColor: Colors.grey.shade500,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color bgColor;

  const _HomeCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: Colors.brown,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

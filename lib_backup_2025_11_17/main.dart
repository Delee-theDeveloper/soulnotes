import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  debugPrint('=== SOULNOTES HOME WIRED ===');
  runApp(const SoulNotesApp());
}

const Color kMaroon = Color(0xFF6D1F1F);
const Color kSoftBeige = Color(0xFFFAF5F2);

class SoulNotesApp extends StatelessWidget {
  const SoulNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoulNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kMaroon),
        scaffoldBackgroundColor: kSoftBeige,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kMaroon,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kMaroon,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      // 🔹 This is your "home page"
      home: const HomeScreen(),
    );
  }
}

/// Optional splash (not used yet, but you can hook it up later if you want)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            'SoulNotes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kMaroon,
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 REMEMBERING HOME PAGE UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftBeige,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                /// LOGO TITLE ("THE REMEMBERING APP")
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'THE',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          color: kMaroon,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'REMEMBERING',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: kMaroon,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'APP',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          color: kMaroon,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// CREATE A TRIBUTE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Hook up navigation to create-tribute screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMaroon,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: const Text('Create A Tribute'),
                  ),
                ),

                const SizedBox(height: 40),

                /// FIRST IMAGE CARD (flowers)
                _ImageCard(
                  assetPath: 'assets/images/flowers.png',
                ),

                const SizedBox(height: 20),

                /// SECOND IMAGE CARD (candle)
                _ImageCard(
                  assetPath: 'assets/images/candle.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple reusable widget for the large image rectangles
class _ImageCard extends StatelessWidget {
final String assetPath = 'assets/splash_logo2.png';

  const _ImageCard({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroon, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        // This keeps the app from crashing if the asset path is wrong
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              'Image not found\n$assetPath',
              textAlign: TextAlign.center,
              style: const TextStyle(color: kMaroon),
            ),
          );
        },
      ),
    );
  }
}

/// Bottom navigation bar
Widget _buildBottomNav() {
  return BottomNavigationBar(
    currentIndex: 0,
    onTap: (index) {
      // TODO: handle tab changes later
    },
    selectedItemColor: kMaroon,
    unselectedItemColor: Colors.grey.shade500,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.sticky_note_2_outlined),
        label: 'Memories',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_outlined),
        label: 'Templates',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ],
  );
}

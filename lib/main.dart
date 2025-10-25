import 'package:flutter/material.dart';

void main() {
  runApp(const SoulNotesApp());
}

class SoulNotesApp extends StatelessWidget {
  const SoulNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoulNotes',
      home: _InlineSignupPage(),
    );
  }
}

class _InlineSignupPage extends StatelessWidget {
  const _InlineSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF5B1A1A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite, color: maroon, size: 72),
            SizedBox(height: 12),
            Text(
              'Inline Signup Page — baseline OK',
              style: TextStyle(color: maroon, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

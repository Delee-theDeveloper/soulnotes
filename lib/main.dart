import 'package:flutter/material.dart';
import 'welcome_flow.dart';

void main() {
  runApp(const SoulNotesApp());
}

class SoulNotesApp extends StatelessWidget {
  const SoulNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoulNotes',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3EDE7),
        useMaterial3: true,
      ),
      home: const WelcomeFlow(),
    );
  }
}

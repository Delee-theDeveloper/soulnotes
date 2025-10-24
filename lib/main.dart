import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConnectionTestScreen(),
    );
  }
}

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _checkFirebase();
  }

  Future<void> _checkFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _connected = true;
      });
    } catch (e) {
      setState(() {
        _connected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _connected
            ? const Text(
                '🔥 Firebase Connected!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              )
            : const Text(
                '⚠️ Not Connected',
                style: TextStyle(fontSize: 22, color: Colors.grey),
              ),
      ),
    );
  }
}

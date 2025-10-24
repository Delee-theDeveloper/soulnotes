import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('SoulNotes Home')),
      body: Center(
        child: Text(
          'Welcome ${user?.email ?? 'Guest'}!',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

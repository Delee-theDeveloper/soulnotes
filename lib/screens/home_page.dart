import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SoulNotes Home"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Welcome to your SoulNotes dashboard 💫",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

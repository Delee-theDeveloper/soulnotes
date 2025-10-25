import 'package:flutter/material.dart';

class SignupMaroonPage extends StatelessWidget {
  const SignupMaroonPage({super.key});

  static const maroon = Color(0xFF5B1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.favorite, color: maroon, size: 72),
              SizedBox(height: 12),
              Text(
                'Welcome to SoulNotes',
                style: TextStyle(
                  color: maroon,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'SignupMaroonPage — alive',
                style: TextStyle(color: maroon, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

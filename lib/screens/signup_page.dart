import 'package:flutter/material.dart';
import 'signup_maroon.dart';

/// Compatibility shim so old routes/imports still work.
/// You can delete this later once all references point to SignupMaroonPage.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  @override
  Widget build(BuildContext context) => const SignupMaroonPage();
}

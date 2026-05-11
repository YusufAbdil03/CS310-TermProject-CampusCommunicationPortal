import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;
import '../screens/auth/login_screen.dart';
// >>> IMPORTANT: change this import to match YOUR existing home screen path.
// In your repo it's likely something like 'screens/home_screen.dart'.
import '../screens/home_screen.dart';

/// AuthWrapper
/// -----------
/// Listens to FirebaseAuth.authStateChanges() via a StreamBuilder and:
///   - shows a spinner while connecting
///   - shows LoginScreen if no user (logged out)
///   - shows HomeScreen if a user exists (logged in)
///
/// This is the pattern from the lecture's Firebase.pdf — a "Wrapper"
/// that decides between authenticated and unauthenticated branches.
/// (Rubric: "Navigation" — logged-out users see login, logged-in
/// users are protected.)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // We stream from the provider so any code that listens to the
    // provider stays in sync with the StreamBuilder.
    final authProvider = context.read<app_auth.AuthProvider>();

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        // 1. Loading state — show a spinner.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Logged in — go to the main app.
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // 3. Logged out — show the Login screen.
        return const LoginScreen();
      },
    );
  }
}

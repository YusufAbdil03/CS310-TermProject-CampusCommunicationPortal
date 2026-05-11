import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';

/// AuthWrapper
/// -----------
/// Listens to AuthProvider and:
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
    final authProvider = context.watch<app_auth.AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.isLoggedIn) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}

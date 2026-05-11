import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;

/// LogoutButton
/// ------------
/// Drop this into any AppBar (or Settings screen) to give the user a
/// way to sign out. AuthWrapper automatically sends them back to the
/// Login screen when FirebaseAuth.signOut() completes.
///
/// Usage:
///   AppBar(actions: [LogoutButton()])
class LogoutButton extends StatelessWidget {
  final bool asIcon;
  const LogoutButton({super.key, this.asIcon = true});

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<app_auth.AuthProvider>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (asIcon) {
      return IconButton(
        tooltip: 'Log out',
        icon: const Icon(Icons.logout),
        onPressed: () => _confirmAndSignOut(context),
      );
    }
    return TextButton.icon(
      onPressed: () => _confirmAndSignOut(context),
      icon: const Icon(Icons.logout),
      label: const Text('Log out'),
    );
  }
}

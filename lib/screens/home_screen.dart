import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

// Step 3: Minimal placeholder — only exists so named route '/home' doesn't crash
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Campus Feed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Home Screen\n(Placeholder)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: AppColors.subtitle),
        ),
      ),
    );
  }
}
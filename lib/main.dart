import 'package:flutter/material.dart';
import 'screens/campus_feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Life Hub',
      debugShowCheckedModeBanner: false,

      // Step 3: App-wide theme using primary color
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'SegoeUICustom',
        useMaterial3: true,
      ),

      // Step 3: Named routes — initial route is Login
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/feed': (context) => const CampusFeedScreen(),
        '/create_post': (context) => const CreatePostScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
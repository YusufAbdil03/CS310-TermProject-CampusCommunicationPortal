import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart' as app_auth;
import 'providers/theme_provider.dart';
import 'widgets/auth_wrapper.dart';

import 'screens/campus_feed_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/messages_list_screen.dart';
import 'screens/other_user_profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/my_profile_screen.dart';
import 'utils/app_colors.dart';
import 'screens/notifications_screen.dart';
import 'screens/clubs_screen.dart';
import 'screens/live_chat_screen.dart';
import 'providers/post_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<app_auth.AuthProvider, PostProvider>(
          create: (_) => PostProvider(),
          update: (_, authProvider, postProvider) {
            final provider = postProvider ?? PostProvider();
            provider.updateUser(authProvider.user?.uid);
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Campus Life Hub',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: 'SegoeUICustom',
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary, brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF121212),
              fontFamily: 'SegoeUICustom',
              useMaterial3: true,
            ),
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/feed': (context) => const CampusFeedScreen(),
              '/create_post': (context) => const CreatePostScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/messages': (context) => MessagesListScreen(),
              '/notifications': (context) => NotificationsScreen(),
              '/clubs': (context) => ClubsScreen(),
              '/chat': (context) => const ChatScreen(otherUserId: 'dummy_id', otherUserName: 'User'),
              '/profile': (context) => MyProfileScreen(),
              '/live_chat': (context) => const LiveChatScreen(),
            },
          );
        },
      ),
    );
  }
}
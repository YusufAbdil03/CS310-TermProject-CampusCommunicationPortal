import 'package:flutter/material.dart';
import 'app_colors.dart';

// Step 3: Utility class for reusable text styles
class AppTextStyles {
  // Large bold title (e.g., "Welcome Back")
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Subtitle below the title
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.subtitle,
  );

  // Label for buttons
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Small link text (e.g., "Forgot Password?")
  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  // Body text (e.g., "Don't have an account?")
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.subtitle,
  );

  // AppBar title style
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
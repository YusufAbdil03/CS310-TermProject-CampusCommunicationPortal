import 'package:flutter/material.dart';

// Step 3: Utility class for reusable spacing constants
class AppSpacing {
  // Small gap (8px)
  static const SizedBox small = SizedBox(height: 8);

  // Medium gap (16px)
  static const SizedBox medium = SizedBox(height: 16);

  // Large gap (24px)
  static const SizedBox large = SizedBox(height: 24);

  // Extra large gap (40px)
  static const SizedBox extraLarge = SizedBox(height: 40);

  // Standard horizontal page padding
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 16);
}
import 'package:flutter/foundation.dart';

class UserProfileState {
  static final ValueNotifier<String?> initial = ValueNotifier<String?>(null);

  static void setInitialFromFullName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      initial.value = null;
      return;
    }

    initial.value = trimmed.substring(0, 1).toUpperCase();
  }
}

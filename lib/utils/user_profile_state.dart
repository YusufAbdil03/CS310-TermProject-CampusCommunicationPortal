import 'package:flutter/foundation.dart';

class UserProfileState {
  static final ValueNotifier<String?> initial = ValueNotifier<String?>(null);
  static String fullName = "User Name";

  static final ValueNotifier<List<Map<String, String>>> myPosts =
      ValueNotifier<List<Map<String, String>>>([]);

  static void setInitialFromFullName(String name) {
    fullName = name;
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      initial.value = null;
      return;
    }

    initial.value = trimmed.substring(0, 1).toUpperCase();
  }

  static void addPost(String content) {
    final newList = List<Map<String, String>>.from(myPosts.value);
      newList.insert(0, {
        'content': content,
        'time': 'Just now',
      });
      myPosts.value = newList;
    }
}

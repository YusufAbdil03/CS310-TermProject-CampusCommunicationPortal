import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        title: Text('Messages', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: ProfileAvatar(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.pagePadding,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search for contacts...',
                  hintStyle: AppTextStyles.subtitle,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  leading: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/other_profile'),
                    child: const ProfileAvatar(),
                  ),
                  title: const Text(
                    'Campus User',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  subtitle: Text(
                    'This message snippet is loaded dynamically from the database...',
                    style: AppTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Text('14:30', style: TextStyle(fontSize: 12, color: AppColors.subtitle)),
                  onTap: () {Navigator.pushNamed(context, '/chat');
                    },
                );
              },
            ),
          ),
          const BottomNavPlaceholder(activeTab: BottomTab.messages),
        ],
      ),
    );
  }
}
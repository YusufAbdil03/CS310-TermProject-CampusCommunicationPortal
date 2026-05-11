import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;
import '../providers/post_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid ?? '';

    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications', style: AppTextStyles.appBarTitle.copyWith(color: isDarkMode ? Colors.white : AppColors.primary)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('isClubAccount', isEqualTo: true)
            .where('members', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final joinedClubs = snapshot.data?.docs ?? [];

          if (joinedClubs.isEmpty) {
            return const Center(
              child: Text(
                'You have no new notifications.\nJoin some clubs to see their updates!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.subtitle, fontSize: 16),
              ),
            );
          }

          final List<String> clubIds = joinedClubs.map((doc) => doc.id).toList();
          final Map<String, String> clubNames = {
            for (var doc in joinedClubs) doc.id: doc['fullName'] ?? 'Club'
          };

          final clubPosts = postProvider.posts.where((post) {
            return clubIds.contains(post.createdBy);
          }).toList();

          if (clubPosts.isEmpty) {
            return const Center(
              child: Text(
                'No recent updates from your clubs.',
                style: TextStyle(color: AppColors.subtitle, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: clubPosts.length,
            separatorBuilder: (context, index) => Divider(color: Theme.of(context).dividerColor),
            itemBuilder: (context, index) {
              final post = clubPosts[index];
              final clubName = clubNames[post.createdBy] ?? 'Club';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.notifications_active, color: Colors.white, size: 20),
                ),
                title: Text(
                  '$clubName posted a new update!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.primary,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.subtitle),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.subtitle),
                onTap: () {
                  Navigator.pushNamed(context, '/feed');
                },
              );
            },
          );
        },
      ),
    );
  }
}
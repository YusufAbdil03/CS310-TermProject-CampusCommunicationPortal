import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/campus_post.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/post_provider.dart';
import '../utils/app_colors.dart';
// YENI EKLENEN SAYFA YOLLARI
import 'my_profile_screen.dart';
import 'other_user_profile_screen.dart';

class CampusFeedScreen extends StatelessWidget {
  const CampusFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final postProvider = context.watch<PostProvider>();
    final authProvider = context.watch<app_auth.AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feed'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(builder: (_) {
            if (postProvider.isLoading) return const Center(child: CircularProgressIndicator());
            if (postProvider.error != null) return Center(child: Text('Error: ${postProvider.error}'));
            if (postProvider.posts.isEmpty) {
              return const Center(
                child: Text('No posts yet.\nBe the first to post!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              );
            }
            return ListView.builder(
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                final CampusPost post = postProvider.posts[index];
                final currentUserId = authProvider.user?.uid;
                final isOwner = post.createdBy == currentUserId;

                return _PostCard(
                  post: post,
                  imageHeight: screenWidth < 420 ? 140 : 180,
                  isOwner: isOwner,
                  currentUserId: currentUserId ?? '',
                  onDelete: () => postProvider.deletePost(post.id),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onDelete,
    required this.imageHeight,
    required this.isOwner,
    required this.currentUserId,
  });

  final CampusPost post;
  final VoidCallback onDelete;
  final double imageHeight;
  final bool isOwner;
  final String currentUserId;

  void _navigateToProfile(BuildContext context, String postOwnerId) {
    if (postOwnerId == currentUserId) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyProfileScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtherUserProfileScreen(userId: postOwnerId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(post.createdBy).get(),
              builder: (context, snapshot) {
                String authorName = 'Loading...';
                if (snapshot.hasData && snapshot.data!.exists) {
                  authorName = snapshot.data!['fullName'] ?? 'Unknown User';
                }
                return InkWell(
                  onTap: () => _navigateToProfile(context, post.createdBy),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          authorName != 'Loading...' && authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authorName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : AppColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (post.networkImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post.networkImageUrl,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) => Container(
                    width: double.infinity, height: imageHeight,
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text('Image unavailable'),
                  ),
                ),
              ),
            if (post.networkImageUrl.isNotEmpty) const SizedBox(height: 10),
            Text(post.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : AppColors.primary)),
            const SizedBox(height: 6),
            Text(post.description, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text('${post.location} • ${post.dateLabel}', style: const TextStyle(color: AppColors.subtitle), overflow: TextOverflow.ellipsis),
                ),
                if (isOwner)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: isDarkMode ? Colors.redAccent : AppColors.primary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
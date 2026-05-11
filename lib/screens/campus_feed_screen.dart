import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/campus_post.dart';
import '../providers/post_provider.dart';
import '../utils/app_colors.dart';

class CampusFeedScreen extends StatefulWidget {
  const CampusFeedScreen({super.key});

  @override
  State<CampusFeedScreen> createState() => _CampusFeedScreenState();
}

class _CampusFeedScreenState extends State<CampusFeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PostProvider>().listenToPosts());
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final postProvider = context.watch<PostProvider>();

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
            if (postProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (postProvider.error != null) {
              return Center(child: Text('Error: ${postProvider.error}'));
            }
            if (postProvider.posts.isEmpty) {
              return const Center(
                child: Text(
                  'No posts yet.\nBe the first to post!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                final CampusPost post = postProvider.posts[index];
                final isOwner = post.createdBy ==
                    FirebaseAuth.instance.currentUser?.uid;
                return _PostCard(
                  post: post,
                  imageHeight: screenWidth < 420 ? 140 : 180,
                  isOwner: isOwner,
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
  });

  final CampusPost post;
  final VoidCallback onDelete;
  final double imageHeight;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.networkImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post.networkImageUrl,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) => Container(
                    width: double.infinity,
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text('Image unavailable'),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(post.description),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${post.location} • ${post.dateLabel}',
                    style: const TextStyle(color: AppColors.subtitle),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isOwner)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
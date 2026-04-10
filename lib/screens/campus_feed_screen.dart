import 'package:flutter/material.dart';

import '../models/campus_post.dart';
import '../utils/app_colors.dart';

class CampusFeedScreen extends StatefulWidget {
  const CampusFeedScreen({super.key});

  @override
  State<CampusFeedScreen> createState() => _CampusFeedScreenState();
}

class _CampusFeedScreenState extends State<CampusFeedScreen> {
  final List<CampusPost> _posts = [
    const CampusPost(
      id: '1',
      title: 'CS310 Study Group',
      description: 'Join us at FENS for a collaborative exam prep session.',
      location: 'FENS G062',
      dateLabel: 'Today, 17:30',
      assetImagePath: 'assets/images/campus_banner.png',
      networkImageUrl:
          'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=1200&q=80',
    ),
    const CampusPost(
      id: '2',
      title: 'Robotics Club Meetup',
      description: 'Live demo of autonomous line-following bots in SGM.',
      location: 'SGM 2010',
      dateLabel: 'Tomorrow, 14:00',
      assetImagePath: 'assets/images/campus_banner.png',
      networkImageUrl:
          'https://images.unsplash.com/photo-1581094271901-8022df4466f9?auto=format&fit=crop&w=1200&q=80',
    ),
    const CampusPost(
      id: '3',
      title: 'Career Talk: Product Roles',
      description: 'Alumni panel discussing internships and new grad hiring.',
      location: 'Zoom + SUNUM Hall',
      dateLabel: 'Friday, 12:30',
      assetImagePath: 'assets/images/campus_banner.png',
      networkImageUrl:
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  void _removePost(String id) {
    final int index = _posts.indexWhere((CampusPost post) => post.id == id);
    if (index == -1) {
      return;
    }

    final CampusPost removed = _posts[index];
    setState(() {
      _posts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed: ${removed.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feed'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _posts.isEmpty
              ? const Center(
                  child: Text(
                    'No posts left.\nYou removed all cards.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CampusPost post = _posts[index];
                    return _PostCard(
                      post: post,
                      imageHeight: screenWidth < 420 ? 140 : 180,
                      onRemove: () => _removePost(post.id),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onRemove,
    required this.imageHeight,
  });

  final CampusPost post;
  final VoidCallback onRemove;
  final double imageHeight;

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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                post.assetImagePath,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                post.networkImageUrl,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? _) {
                  return Container(
                    width: double.infinity,
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text('Network image failed to load'),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
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
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

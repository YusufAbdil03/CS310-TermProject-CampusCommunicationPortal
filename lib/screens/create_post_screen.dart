import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/campus_post.dart';
import '../providers/post_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/profile_avatar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and content')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final post = CampusPost(
        id: '',
        title: _titleController.text.trim(),
        description: _contentController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? 'Campus'
            : _locationController.text.trim(),
        dateLabel: _formattedDate(),
        assetImagePath: 'assets/images/campus_banner.png',
        networkImageUrl: '',
        createdBy: user?.uid ?? '',
        createdAt: DateTime.now(),
      );

      await context.read<PostProvider>().addPost(post);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Student',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileAvatar(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Post',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF141444),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your thought or moment\nwith the campus',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF4A4A4A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),

            // Post Title Field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF141444),
                      size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Post Title:',
                        labelStyle: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF141444),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Book Sale',
                        hintStyle: TextStyle(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white54
                                : Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Location Field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF141444),
                      size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Location:',
                        labelStyle: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF141444),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'FENS G062',
                        hintStyle: TextStyle(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white54
                                : Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // What's on your mind Field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(minHeight: 180),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's on your mind?",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Share something with the campus...',
                      hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Post Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isPosting ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isPosting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Post',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
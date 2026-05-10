import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/profile_avatar.dart';
import '../utils/user_profile_state.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 20),
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
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444), // Slightly darker blue for header
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your thought or moment\nwith the campus',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF4A4A4A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            
            // Post Title Field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F0), // Light greyish background
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444), size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Post Title:',
                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Book Sale',
                        hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54),
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
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(minHeight: 180),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Book Sale\nBook Sale, Book Event Alerts,\nBook Sale, iBook Books and\nBook Sale',
                      hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Attach Image item
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.image_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444), size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Attach Image',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF141444)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Post Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  String finalPost = "${_titleController.text}: ${_contentController.text}";
                  UserProfileState.addPost(finalPost);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

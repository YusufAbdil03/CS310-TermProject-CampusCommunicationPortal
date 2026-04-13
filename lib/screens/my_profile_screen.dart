import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../utils/user_profile_state.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Student', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: ProfileAvatar(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // AVATAR
            ValueListenableBuilder<String?>(
              valueListenable: UserProfileState.initial,
              builder: (context, initialValue, child) {
                return CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    initialValue ?? "?",
                    style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // DÜZELTME: Artık "Student Profile" değil, kayıt olunan isim yazar
            Text(UserProfileState.fullName, style: AppTextStyles.pageTitle),

            const SizedBox(height: 24),

            // BIO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Bio', style: AppTextStyles.subtitle),
                    const SizedBox(height: 4),
                    const Text("No bio available yet.", style: AppTextStyles.body),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text('Edit Profile', style: AppTextStyles.buttonLabel),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Posts', style: AppTextStyles.pageTitle.copyWith(fontSize: 20)),
              ),
            ),

            const SizedBox(height: 20),

            // MyPosts
            ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: UserProfileState.myPosts,
              builder: (context, posts, child) {
                if (posts.isEmpty) {
                  return Column(
                    children: [
                      const Icon(Icons.post_add_rounded, size: 64, color: Color(0xFFD1D5DB)),
                      const SizedBox(height: 12),
                      const Text("You haven't posted anything yet.", style: AppTextStyles.subtitle),
                    ],
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const ProfileAvatar(),
                      title: Text(posts[index]['content']!),
                      subtitle: Text(posts[index]['time']!),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),
            const BottomNavPlaceholder(activeTab: BottomTab.home),
          ],
        ),
      ),
    );
  }
}
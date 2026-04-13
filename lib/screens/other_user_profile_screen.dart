import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../widgets/profile_avatar.dart';

class OtherUserProfileScreen extends StatelessWidget {
  const OtherUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Student Profile', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileAvatar(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.primary,
                child: CircleAvatar(
                  radius: 53,
                  backgroundColor: Color(0xFFF0F2F0),
                  child: Icon(Icons.person, size: 60, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('User Full Name', style: AppTextStyles.pageTitle),
            const SizedBox(height: 4),
            Text('Student Department', style: AppTextStyles.subtitle),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'User biography and personal information pulled dynamically from the system backend.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  label: Text('Send Message', style: AppTextStyles.buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF141444)),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dynamic post content title placeholder.',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      const Text('Time ago', style: TextStyle(fontSize: 12, color: AppColors.subtitle)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
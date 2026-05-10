import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/bottom_nav_placeholder.dart';

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> clubs = [
      {
        'name': 'Robotics Club',
        'description': 'Build robots and join competitions.',
      },
      {
        'name': 'Music Club',
        'description': 'Jam sessions, performances, and events.',
      },
      {
        'name': 'Entrepreneurship Club',
        'description': 'Startup ideas, networking, and workshops.',
      },
      {
        'name': 'Art Club',
        'description': 'Creative projects, exhibitions, and activities.',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Clubs',
          style: AppTextStyles.appBarTitle.copyWith(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: clubs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final club = clubs[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputBorder.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 1.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  club['description']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.subtitle,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavPlaceholder(activeTab: BottomTab.clubs),
    );
  }
}
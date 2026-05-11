import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/club_model.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../services/firestore_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/bottom_nav_placeholder.dart';

class ClubsScreen extends StatelessWidget {
  ClubsScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid ?? '';

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
        title: Text('Clubs', style: AppTextStyles.appBarTitle.copyWith(color: isDarkMode ? Colors.white : AppColors.primary)),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CampusClub>>(
        stream: _firestoreService.getClubsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final clubs = snapshot.data ?? [];

          if (clubs.isEmpty) {
            return const Center(
              child: Text(
                'No clubs available yet.\nAdmins will add them soon!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.subtitle, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: clubs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final club = clubs[index];
              final isMember = club.members.contains(currentUserId);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF4F7FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder.withValues(alpha: isDarkMode ? 0.3 : 1.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            club.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                        Icon(
                          isMember ? Icons.notifications_active : Icons.notifications_off_outlined,
                          size: 20,
                          color: isMember ? Colors.orange : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      club.description,
                      style: const TextStyle(fontSize: 14, color: AppColors.subtitle, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (isMember) {
                              await _firestoreService.leaveClub(club.id, currentUserId);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Left ${club.name}')),
                                );
                              }
                            } else {
                              await _firestoreService.joinClub(club.id, currentUserId);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Joined ${club.name}! You will now receive updates.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMember ? Colors.red.shade400 : AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isMember ? 'Leave Club' : 'Join Club'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavPlaceholder(activeTab: BottomTab.clubs),
    );
  }
}
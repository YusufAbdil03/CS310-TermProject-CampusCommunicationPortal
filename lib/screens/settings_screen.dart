import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/bottom_nav_placeholder.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _newPostNotifications = true;
  bool _clubEventAlerts = true;
  bool _directMessages = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141444),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your app and account\npreferences',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4A4A4A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            
            // Settings List Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _SettingsToggle(
                    title: 'New Post Notifications',
                    value: _newPostNotifications,
                    onChanged: (val) => setState(() => _newPostNotifications = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
                  _SettingsToggle(
                    title: 'Club Event Alerts',
                    value: _clubEventAlerts,
                    onChanged: (val) => setState(() => _clubEventAlerts = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
                  _SettingsToggle(
                    title: 'Direct Messages',
                    value: _directMessages,
                    onChanged: (val) => setState(() => _directMessages = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF141444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF141444)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Log Out Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Log out action
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C), // Deep Red
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Log Out',
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
      bottomNavigationBar: const BottomNavPlaceholder(activeTab: BottomTab.settings),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF141444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

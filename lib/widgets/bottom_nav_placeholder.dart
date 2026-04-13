import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

enum BottomTab { anonym, messages, home, clubs, settings }

class BottomNavPlaceholder extends StatelessWidget {
  final BottomTab activeTab;

  const BottomNavPlaceholder({
    super.key,
    this.activeTab = BottomTab.home,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.masks_outlined,
            label: 'Anonym\nChat',
            isActive: activeTab == BottomTab.anonym,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            isActive: activeTab == BottomTab.messages,
            onTap: () {if (activeTab != BottomTab.messages) {
              Navigator.pushNamed(context, '/messages');
            }},
          ),
          _NavItem(
            icon: activeTab == BottomTab.home ? Icons.home : Icons.home_outlined,
            label: 'Home',
            isActive: activeTab == BottomTab.home,
            onTap: () {
              if (activeTab != BottomTab.home) {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
          _NavItem(
      icon: Icons.campaign_outlined,
  label: 'Clubs',
  isActive: activeTab == BottomTab.clubs,
  onTap: () {
    if (activeTab != BottomTab.clubs) {
      Navigator.pushNamed(context, '/clubs');
    }
  },
),
          _NavItem(
            icon: activeTab == BottomTab.settings ? Icons.settings : Icons.settings_outlined,
            label: 'Settings',
            isActive: activeTab == BottomTab.settings,
            onTap: () {
              if (activeTab != BottomTab.settings) {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.subtitle;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

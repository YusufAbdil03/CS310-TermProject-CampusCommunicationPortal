import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class BottomNavPlaceholder extends StatelessWidget {
  const BottomNavPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.masks_outlined, label: 'Anonym\nChat'),
          _NavItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
          _NavItem(icon: Icons.home, label: 'Home', isActive: true),
          _NavItem(icon: Icons.campaign_outlined, label: 'Clubs'),
          _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
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
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.subtitle;
    return Column(
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
    );
  }
}

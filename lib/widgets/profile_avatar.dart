import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/user_profile_state.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: UserProfileState.initial,
      builder: (context, initial, _) {
        if (initial == null || initial.isEmpty) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEAF0FA),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primary.withValues(alpha: 0.5),
              size: size * 0.58,
            ),
          );
        }

        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.45,
            ),
          ),
        );
      },
    );
  }
}

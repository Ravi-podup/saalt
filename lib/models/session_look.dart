import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// One of the looks a session can carry. There is no image picker in the app,
/// so a session without a photograph is given artwork by choosing a topic
/// glyph and palette.
class SessionLook {
  const SessionLook({
    required this.label,
    required this.icon,
    required this.tint,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final Color accent;
}

const sessionLooks = <SessionLook>[
  SessionLook(
    label: 'Cups',
    icon: Icons.water_drop_rounded,
    tint: AppColors.roseTint,
    accent: AppColors.rose,
  ),
  SessionLook(
    label: 'Discs',
    icon: Icons.donut_large_rounded,
    tint: AppColors.tealTint,
    accent: AppColors.teal,
  ),
  SessionLook(
    label: 'Flow',
    icon: Icons.shield_moon_rounded,
    tint: AppColors.periwinkleTint,
    accent: AppColors.periwinkle,
  ),
  SessionLook(
    label: 'Teens',
    icon: Icons.favorite_rounded,
    tint: AppColors.apricotTint,
    accent: AppColors.apricot,
  ),
  SessionLook(
    label: 'Wellbeing',
    icon: Icons.self_improvement_rounded,
    tint: AppColors.lilacTint,
    accent: AppColors.lilac,
  ),
  SessionLook(
    label: 'Planet',
    icon: Icons.eco_rounded,
    tint: AppColors.sageTint,
    accent: AppColors.sage,
  ),
];

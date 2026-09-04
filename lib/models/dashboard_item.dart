import 'package:flutter/material.dart';

/// One entry in the dashboard grid.
class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  /// Soft background wash for the card.
  final Color tint;

  /// Saturated colour used for the icon and its badge.
  final Color accent;
}

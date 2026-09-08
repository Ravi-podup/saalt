import 'package:flutter/material.dart';

/// One entry in the dashboard grid.
class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.accent,
    required this.imageAsset,
    this.secondImageAsset,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  final Color tint;

  final Color accent;

  final String imageAsset;

  final String? secondImageAsset;
}

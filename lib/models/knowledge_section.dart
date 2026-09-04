import 'package:flutter/material.dart';

/// One choice on the knowledgebase landing screen. Picking a section opens the
/// knowledge filed under it.
class KnowledgeSection {
  const KnowledgeSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.accent,
    this.isVideo = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final Color accent;

  /// This section's knowledge is watched rather than read.
  final bool isVideo;
}

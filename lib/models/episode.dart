import 'package:flutter/material.dart';

/// One episode of The Saalt Show.
class Episode {
  const Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.guest,
    required this.date,
    required this.minutes,
    required this.format,
    required this.tint,
    required this.accent,
    this.isNew = false,
    this.imageAsset,
    this.videoUrl,
  });

  final String id;
  final int number;
  final String title;

  /// Who is on the episode, without the "with" prefix.
  final String guest;

  final String date;
  final int minutes;

  /// Customer Stories, Expert Interviews or Community Roundtables.
  final String format;

  final bool isNew;

  /// Real episode artwork once it exists. While null the art is drawn from
  /// [tint], [accent] and the wordmark instead.
  final String? imageAsset;

  /// Streamable episode video. Null means the episode is not watchable yet.
  final String? videoUrl;

  bool get hasVideo => videoUrl != null;
  final Color tint;
  final Color accent;
}

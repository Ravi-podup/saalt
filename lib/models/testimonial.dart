import 'package:flutter/material.dart';

/// A customer review shown on the testimonials screen.
class Testimonial {
  const Testimonial({
    required this.id,
    required this.author,
    required this.rating,
    required this.timeAgo,
    required this.product,
    required this.quote,
    required this.helpfulCount,
    required this.avatarTint,
    required this.avatarAccent,
    this.isVerified = false,
    this.imageAsset,
    this.videoUrl,
    this.minutes = 0,
  });

  final String id;
  final String author;

  /// Whole stars, 1 to 5.
  final int rating;

  final String timeAgo;

  /// Which product this review is about.
  final String product;

  final String quote;

  /// Confirmed purchase.
  final bool isVerified;

  /// Still frame shown before the clip plays.
  final String? imageAsset;

  /// The testimonial clip itself.
  final String? videoUrl;

  /// Runtime of the clip.
  final int minutes;

  bool get hasVideo => videoUrl != null;

  final int helpfulCount;
  final Color avatarTint;
  final Color avatarAccent;

  String get initial =>
      author.isEmpty ? '?' : author.substring(0, 1).toUpperCase();
}

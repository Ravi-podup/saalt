import 'package:flutter/material.dart';

/// One piece of knowledge - an article, or a clip when [isVideo] is set.
class Article {
  const Article({
    required this.title,
    required this.excerpt,
    required this.section,
    required this.category,
    required this.minutes,
    required this.icon,
    required this.tint,
    required this.accent,
    this.isVideo = false,
  });

  final String title;
  final String excerpt;

  /// Which knowledgebase section files this, e.g. Products or Testimonials.
  final String section;

  /// Finer-grained tag shown on the row, e.g. Sizing or Care.
  final String category;

  /// Minutes to read, or to watch when [isVideo].
  final int minutes;

  final bool isVideo;

  final IconData icon;
  final Color tint;
  final Color accent;

  /// Matches against a lowercase search term.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        excerpt.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q);
  }
}

/// A short question and answer pair for the quick-answers list.
class Faq {
  const Faq({required this.question, required this.answer});

  final String question;
  final String answer;
}

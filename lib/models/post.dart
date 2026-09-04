import 'package:flutter/material.dart';

/// A single entry in the community timeline.
class Post {
  const Post({
    required this.id,
    required this.author,
    required this.timeAgo,
    required this.group,
    required this.body,
    required this.helpfulCount,
    required this.commentCount,
    required this.avatarTint,
    required this.avatarAccent,
    this.badge,
    this.tags = const [],
    this.imageAsset,
    this.isVideo = false,
  });

  final String id;
  final String author;

  /// Community standing, e.g. MENTOR or AMBASSADOR. Null for regular members.
  final String? badge;

  final String timeAgo;
  final String group;
  final String body;
  final List<String> tags;

  /// Optional photo attached to the post.
  final String? imageAsset;

  /// Attachment is a clip; [imageAsset] is then its still frame.
  final bool isVideo;

  final int helpfulCount;
  final int commentCount;

  final Color avatarTint;
  final Color avatarAccent;

  /// First letter of the author's name, for the avatar.
  String get initial =>
      author.isEmpty ? '?' : author.substring(0, 1).toUpperCase();
}

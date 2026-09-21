import 'package:saalt/models/post.dart';
import 'package:saalt/res/app_images.dart';
import 'package:flutter/material.dart';

class CommunityHelper {
  /// The two posts the timeline shows. Kept short on purpose: this is a
  /// design screen, and the filters above it do not narrow the list.
  static const timeline = <Post>[
    Post(
      id: 'p1',
      author: 'Sophia',
      badge: 'AMBASSADOR',
      timeAgo: '2h ago',
      group: 'Cup life',
      body:
          'Three cycles in and I finally got the seal right. What helped: '
          'stop aiming straight up and angle it back toward your tailbone '
          'instead.',
      tags: ['CupLife', 'Leaks'],
      imageAsset: AppImages.communityContentImg,
      helpfulCount: 258,
      commentCount: 80,
      avatarTint: Color(0x1AC95878),
      avatarAccent: Color(0xFFC95878),
    ),
    Post(
      id: 'p2',
      author: 'Charlotte',
      badge: 'MENTOR',
      timeAgo: '2h ago',
      group: 'Cup life',
      body:
          'Three cycles in and I finally got the seal right. What helped: '
          'stop aiming straight up and angle it back toward your tailbone '
          'instead.',
      tags: ['CupLife', 'Leaks'],
      helpfulCount: 24,
      commentCount: 8,
      avatarTint: Color(0x1A555F70),
      avatarAccent: Color(0xFF555F70),
    ),
  ];
}

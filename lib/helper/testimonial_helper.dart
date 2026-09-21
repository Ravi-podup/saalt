import 'package:flutter/material.dart';
import 'package:saalt/models/testimonial.dart';
import 'package:saalt/res/app_images.dart';

class TestimonialHelper {
  static const filters = [
    'All Topics',
    'Cup & Discs',
    'Saalt Wear',
    'Cleaning & Accessories',
  ];

  /// The two stories the screen shows. The filters above them are a design
  /// element; the list does not narrow.
  static const reviews = <Testimonial>[
    Testimonial(
      id: 't1',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-3-saalt-jessica_-new-2.mp4',
      imageAsset: AppImages.storyCupVideoImg,
      author: 'Sophia',
      rating: 5,
      timeAgo: '2 days ago',
      product: 'Period Underwear',
      productIcon: AppImages.underwearIcon,
      isVerified: true,
      quote:
          '"Three cycles in and I finally got the seal right. What helped: '
          'stop aiming straight up and angle it back toward your tailbone '
          'instead."',
      tags: ['CupLife', 'Leaks'],
      helpfulCount: 258,
      avatarTint: Color(0x1AC95878),
      avatarAccent: Color(0xFFC95878),
    ),
    Testimonial(
      id: 't2',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-4_new2907.mp4',
      imageAsset: AppImages.storyStreetVideoImg,
      stillHasPlayBadge: true,
      author: 'Charlotte',
      rating: 5,
      timeAgo: '2 days ago',
      product: 'Saalt Discs',
      productIcon: AppImages.discIcon,
      isVerified: true,
      quote:
          '"Three cycles in and I finally got the seal right. What helped: '
          'stop aiming straight up and angle it back toward your tailbone '
          'instead."',
      tags: ['SaaltDiscs'],
      helpfulCount: 258,
      avatarTint: Color(0x1A555F70),
      avatarAccent: Color(0xFF555F70),
    ),
  ];

  /// What the summary tiles report. Stated rather than counted: they speak
  /// for the whole catalogue, not for the two stories on screen.
  static const displayRating = 4.9;
  static const happyUsers = '12k+';

  /// Mean score across [reviews], to one decimal place.
  static double get average =>
      reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

  /// How many reviews sit at each star level, 5 down to 1.
  static Map<int, int> get distribution => {
    for (final star in [5, 4, 3, 2, 1])
      star: reviews.where((r) => r.rating == star).length,
  };

  /// The products people have actually filmed about, for the picker on the
  /// submission screen. Shorter and more relevant than the whole catalogue.
  static List<String> get reviewedProducts {
    final seen = <String>[];
    for (final review in reviews) {
      if (!seen.contains(review.product)) seen.add(review.product);
    }
    seen.sort();
    return seen;
  }

  /// What to talk about, so a blank camera is less daunting.
  static const prompts = <String>[
    'What were you using before?',
    'What changed in the first cycle?',
    'What would you tell a friend who is hesitating?',
  ];

  /// What we ask of a clip.
  static const clipRules = <({IconData icon, String text})>[
    (icon: Icons.timer_outlined, text: '30 to 90 seconds'),
    (icon: Icons.stay_current_portrait_rounded, text: 'Portrait or landscape'),
    (icon: Icons.hd_outlined, text: 'MP4 or MOV, up to 200 MB'),
  ];
}

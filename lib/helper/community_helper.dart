import 'package:saalt/models/post.dart';
import 'package:saalt/res/app_colors.dart';

class CommunityHelper {
  static const timeline = <Post>[
    Post(
      id: 'p1',
      author: 'Priya',
      badge: 'MENTOR',
      timeAgo: '2h ago',
      group: 'Cup life',
      body:
          'Three cycles in and I finally got the seal right. What helped: '
          'stop aiming straight up and angle it back toward your tailbone '
          'instead. If you are still leaking on day two, try that before '
          'you size up.',
      tags: ['CupLife', 'Leaks'],
      helpfulCount: 24,
      commentCount: 8,
      avatarTint: AppColors.roseTint,
      avatarAccent: AppColors.rose,
    ),
    Post(
      id: 'p2',
      author: 'Kayla',
      timeAgo: '5h ago',
      group: 'First period',
      body:
          'The first period kit arrived for my daughter today. She had the '
          'whole thing organised into her own pouch before I could even '
          'start explaining it.',
      imageAsset: 'assets/images/saalt_cup.jpg',
      helpfulCount: 61,
      commentCount: 12,
      avatarTint: AppColors.sageTint,
      avatarAccent: AppColors.sage,
    ),
    Post(
      id: 'p3',
      author: 'Renee',
      badge: 'AMBASSADOR',
      timeAgo: '8h ago',
      group: 'Sustainability',
      body:
          'Did the maths on four years of cup use this morning: roughly 900 '
          'tampons that never got made, and about \$420 I did not spend. '
          'Still the same cup.',
      tags: ['Sustainability'],
      helpfulCount: 143,
      commentCount: 27,
      avatarTint: AppColors.tealTint,
      avatarAccent: AppColors.teal,
    ),
    Post(
      id: 'p4',
      author: 'Tomi',
      timeAgo: '1d ago',
      group: 'Postpartum',
      body:
          'Six weeks postpartum and the CloudShort is the only thing I have '
          'worn that does not feel like a diaper. Nobody warned me about '
          'that part of recovery.',
      tags: ['Postpartum'],
      imageAsset: 'assets/images/leakproof_comfort_cloudshort.jpg',
      helpfulCount: 88,
      commentCount: 19,
      avatarTint: AppColors.periwinkleTint,
      avatarAccent: AppColors.periwinkle,
    ),
    Post(
      id: 'p5',
      author: 'Sam',
      timeAgo: '1d ago',
      group: 'Heavy flow',
      body:
          'PSA for heavy-flow people: the disc genuinely holds more than the '
          'cup. Switched last cycle and stopped setting a 3am alarm.',
      tags: ['HeavyFlow', 'Discs'],
      imageAsset: 'assets/images/menstrual_disc.jpg',
      isVideo: true,
      helpfulCount: 52,
      commentCount: 14,
      avatarTint: AppColors.apricotTint,
      avatarAccent: AppColors.apricot,
    ),
    Post(
      id: 'p6',
      author: 'Dee',
      badge: 'MENTOR',
      timeAgo: '2d ago',
      group: 'Teens',
      body:
          'Teaching my thirteen-year-old about her cycle without the shame '
          'spiral I grew up with. The knowledgebase articles gave me words '
          'I did not have.',
      tags: ['Teens'],
      helpfulCount: 76,
      commentCount: 9,
      avatarTint: AppColors.lilacTint,
      avatarAccent: AppColors.lilac,
    ),
  ];
}

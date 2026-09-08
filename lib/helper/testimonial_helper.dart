import 'package:saalt/models/testimonial.dart';
import 'package:saalt/res/app_colors.dart';

class TestimonialHelper {
  static const filters = ['All', '5 stars', '4 stars', 'Verified'];

  static const reviews = <Testimonial>[
    Testimonial(
      id: 't1',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-3-saalt-jessica_-new-2.mp4',
      minutes: 4,
      imageAsset: 'assets/images/saalt_cup.jpg',
      author: 'Alina',
      rating: 5,
      timeAgo: '2 days ago',
      product: 'Saalt Cup',
      isVerified: true,
      quote:
          'Three cycles in and I have stopped thinking about my period at all. '
          'Twelve hours, no checking, no bag full of supplies. I did not '
          'expect the mental quiet to be the best part.',
      helpfulCount: 128,
      avatarTint: AppColors.roseTint,
      avatarAccent: AppColors.rose,
    ),
    Testimonial(
      id: 't2',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-4_new2907.mp4',
      minutes: 6,
      author: 'Marisol',
      rating: 5,
      timeAgo: '5 days ago',
      product: 'Leakproof Seamless Brief',
      isVerified: true,
      quote:
          'Wore these through a fourteen-hour travel day on my heaviest day '
          'and landed completely dry. No liner, no backup, no anxiety about '
          'standing up.',
      imageAsset: 'assets/images/leakproof_seamless_brief.jpg',
      helpfulCount: 94,
      avatarTint: AppColors.apricotTint,
      avatarAccent: AppColors.apricot,
    ),
    Testimonial(
      id: 't3',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-2-2007.mp4',
      minutes: 5,
      imageAsset: 'assets/images/menstrual_disc.jpg',
      author: 'Jess',
      rating: 4,
      timeAgo: '1 week ago',
      product: 'Saalt Disc',
      quote:
          'Took me two tries to get the angle right and I nearly gave up. '
          'Third attempt it clicked, and removal is genuinely mess-free now. '
          'Worth pushing through the learning curve.',
      helpfulCount: 61,
      avatarTint: AppColors.tealTint,
      avatarAccent: AppColors.teal,
    ),
    Testimonial(
      id: 't4',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-5_final-edits0909.mp4',
      minutes: 8,
      author: 'Nneka',
      rating: 5,
      timeAgo: '1 week ago',
      product: 'Leakproof Comfort CloudShort',
      isVerified: true,
      quote:
          'Postpartum was the first time in my life something designed for '
          'bleeding did not feel like a punishment. I bought three more pairs '
          'in week two.',
      imageAsset: 'assets/images/leakproof_comfort_cloudshort.jpg',
      helpfulCount: 212,
      avatarTint: AppColors.periwinkleTint,
      avatarAccent: AppColors.periwinkle,
    ),
    Testimonial(
      id: 't5',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-3-saalt-jessica_-new-2.mp4',
      minutes: 3,
      imageAsset: 'assets/images/saalt_soft_cup.jpg',
      author: 'Robin',
      rating: 5,
      timeAgo: '2 weeks ago',
      product: 'Saalt Soft Cup',
      isVerified: true,
      quote:
          'I have a sensitive bladder and the firmer cup pressed in a way I '
          'could not ignore. The soft version solved it completely. Wish I had '
          'started here.',
      helpfulCount: 87,
      avatarTint: AppColors.lilacTint,
      avatarAccent: AppColors.lilac,
    ),
    Testimonial(
      id: 't6',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-2-2007.mp4',
      minutes: 4,
      imageAsset: 'assets/images/saalt_cup.jpg',
      author: 'Devi',
      rating: 3,
      timeAgo: '2 weeks ago',
      product: 'Saalt Cup',
      quote:
          'The cup itself is well made and the seal is good. Being honest '
          'though, even the small was firmer than I wanted. Might be a body '
          'thing rather than a product fault.',
      helpfulCount: 44,
      avatarTint: AppColors.sageTint,
      avatarAccent: AppColors.sage,
    ),
    Testimonial(
      id: 't7',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-4_new2907.mp4',
      minutes: 2,
      author: 'Hana',
      rating: 5,
      timeAgo: '3 weeks ago',
      product: 'Leakproof Seamless Thong',
      isVerified: true,
      quote:
          'Bought one pair to test the claim. I own six now. That is the whole '
          'review.',
      imageAsset: 'assets/images/leakproof_seamless_thong.jpg',
      helpfulCount: 156,
      avatarTint: AppColors.roseTint,
      avatarAccent: AppColors.rose,
    ),
    Testimonial(
      id: 't8',
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-5_final-edits0909.mp4',
      minutes: 5,
      imageAsset: 'assets/images/saalt_disc_duo.jpg',
      author: 'Tara',
      rating: 4,
      timeAgo: '1 month ago',
      product: 'Saalt Disc Duo',
      quote:
          'Having both sizes means I actually use the right one for the day '
          'instead of forcing it. Only wish is that the case were smaller.',
      helpfulCount: 38,
      avatarTint: AppColors.apricotTint,
      avatarAccent: AppColors.apricot,
    ),
  ];

  /// Mean score across [reviews], to one decimal place.
  static double get average =>
      reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

  /// How many reviews sit at each star level, 5 down to 1.
  static Map<int, int> get distribution => {
    for (final star in [5, 4, 3, 2, 1])
      star: reviews.where((r) => r.rating == star).length,
  };
}

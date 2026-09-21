import 'package:saalt/models/episode.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class ShowHelper {
  /// Doubles as the episode filter: the show's three formats.
  static const formats = [
    'All Episodes',
    'User Stories',
    'Expert Interviews',
    'Community Roundtables',
  ];

  /// Newest first. Numbering, dates and formats follow the published show;
  /// each video is the file whose name carries the matching episode number.
  static const episodes = <Episode>[
    Episode(
      id: 'e05',
      number: 5,
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-5_final-edits0909.mp4',
      title: 'Perimenopause: The Decade Nobody Warned You About',
      guest: 'Dr. Anita Rao',
      date: '1 Sep 2026',
      minutes: 45,
      format: 'Expert Interviews',
      isNew: true,
      imageAsset: AppImages.episode1Img,
      coverAsset: AppImages.saaltShow1Img,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Episode(
      id: 'e04',
      number: 4,
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-4_new2907.mp4',
      title: 'Weird, But Worth It: Making Peace With Her Period at 40',
      guest: 'Lily Palmer',
      date: '3 Aug 2026',
      minutes: 41,
      format: 'User Stories',
      imageAsset: AppImages.episode2Img,
      coverAsset: AppImages.saaltShow2Img,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Episode(
      id: 'e03',
      number: 3,
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-3-saalt-jessica_-new-2.mp4',
      title: 'Why This Marathon Runner Calls Her Period a Privilege',
      guest: 'Jessica Davis',
      date: '29 Jul 2026',
      minutes: 36,
      format: 'User Stories',
      imageAsset: AppImages.episode3Img,
      coverAsset: AppImages.saaltShow3Img,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Episode(
      id: 'e02',
      number: 2,
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-2-2007.mp4',
      title: 'Eight in Ten Felt Better After Ditching Tampons',
      guest: 'Kim Rosas',
      date: '13 Jul 2026',
      minutes: 48,
      format: 'Expert Interviews',
      imageAsset: 'assets/images/menstrual_disc.jpg',
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    // Only four files were supplied for five episodes, so the origin story
    // reuses the last one until its own render exists.
    Episode(
      id: 'e01',
      number: 1,
      videoUrl:
          'https://storageapi.podup.com/production/2851/files/files/episode-2-2007.mp4',
      title: 'The Phone Call that Inspired Saalt',
      guest: 'Cherie & Jon Hoeger',
      date: '3 Jul 2026',
      minutes: 52,
      format: 'Community Roundtables',
      imageAsset: 'assets/images/saalt_disc_duo.jpg',
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
  ];

  /// Where to listen. Each name is matched to its brand mark in PlatformRow.
  static const platforms = [
    'YouTube',
    'Spotify',
    'Apple',
    'Amazon',
    'Vimeo',
    'iHeartRadio',
    'Overcast',
  ];
}

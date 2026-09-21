import 'package:flutter/material.dart';
import 'package:saalt/helper/testimonial_helper.dart';
import 'package:saalt/models/testimonial.dart';
import 'package:saalt/presentation/testimonials/widgets/testimonial_card.dart';
import 'package:saalt/presentation/testimonials/share_story_screen.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/res/app_images.dart';
import 'package:saalt/router/app_route_paths.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.testimonialsScreen);
  }

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  String _filter = TestimonialHelper.filters.first;
  final _helpful = <String>{};

  /// The chips are a design element: picking one marks it, but the stories
  /// below stay as they are.
  List<Testimonial> get _visible => TestimonialHelper.reviews;

  void _play(Testimonial review) {
    // Captured in a local so the null check promotes: a field on another
    // object cannot be promoted in place.
    final url = review.videoUrl;
    if (url == null) return;
    VideoPlayerScreen.open(
      context,
      title: review.quote.split('.').first,
      subtitle: '${review.author} · ${review.product}',
      url: url,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _visible;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _StoriesHeader(
              onBack: () => context.pop(),
              onRecord: () => ShareStoryScreen.open(context),
            ),
            Expanded(
              child: ListView.separated(
                key: const Key('testimonials-list'),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                itemCount: reviews.length + 2,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == 0) return const _SummaryTiles();
                  if (index == 1) {
                    return _FilterBar(
                      filters: TestimonialHelper.filters,
                      selected: _filter,
                      onSelect: (f) => setState(() => _filter = f),
                    );
                  }
                  final review = reviews[index - 2];
                  return TestimonialCard(
                    review: review,
                    onPlay: () => _play(review),
                    isHelpful: _helpful.contains(review.id),
                    onHelpful: () => setState(() {
                      _helpful.contains(review.id)
                          ? _helpful.remove(review.id)
                          : _helpful.add(review.id);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back on the left, the section named in the middle, the camera and the
/// viewer's own face opposite.
class _StoriesHeader extends StatelessWidget {
  const _StoriesHeader({this.onBack, this.onRecord});

  final VoidCallback? onBack;
  final VoidCallback? onRecord;

  /// One button on the left, two on the right. Kept clear of the widest
  /// side so the title can sit on the screen's centre line, not between
  /// the buttons.
  static const _clearance = 92.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: _clearance),
            child: Column(
              children: [
                Text(
                  'Stories',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkDeep,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Real people, on camera',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppColors.inkDeep),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _BackButton(onTap: onBack),
              const Spacer(),
              GestureDetector(
                onTap: onRecord,
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  AppImages.recordButtonIcon,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                AppImages.profilePictureCircleImage,
                height: 40,
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 19,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

/// What the whole catalogue says, before any one story does.
class _SummaryTiles extends StatelessWidget {
  const _SummaryTiles();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _RatingTile()),
          SizedBox(width: 12),
          Expanded(child: _UsersTile()),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _RatingTile extends StatelessWidget {
  const _RatingTile();

  @override
  Widget build(BuildContext context) {
    return const _Tile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '4.9',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  // letterSpacing: -0.6,
                  color: AppColors.inkDeep,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '/5',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffC95878),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          StarRating(rating: TestimonialHelper.displayRating, size: 14),
          SizedBox(height: 8),
          Text(
            'OVERALL RATING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Color(0xff555F70),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTile extends StatelessWidget {
  const _UsersTile();

  @override
  Widget build(BuildContext context) {
    return _Tile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            TestimonialHelper.happyUsers,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              color: AppColors.inkDeep,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'HAPPY USERS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Color(0xff555F70),
            ),
          ),
          const SizedBox(height: 10),
          // Left-aligned rather than stretched: the artwork is three faces,
          // not a bar.
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              AppImages.happyUsersImg,
              height: 26,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox(height: 26),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        key: const Key('testimonial-filters'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = filter == selected;
          return Material(
            color: isActive ? AppColors.blackColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => onSelect(filter),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.ink : Color(0xffF3F4F6),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? Colors.white : Color(0xff4B5563),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

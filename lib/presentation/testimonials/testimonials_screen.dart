import 'package:flutter/material.dart';
import 'package:saalt/helper/testimonial_helper.dart';
import 'package:saalt/models/testimonial.dart';
import 'package:saalt/presentation/testimonials/widgets/rating_summary.dart';
import 'package:saalt/presentation/testimonials/widgets/testimonial_card.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/res/app_colors.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key});

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  String _filter = 'All';
  final _helpful = <String>{};

  List<Testimonial> get _visible => switch (_filter) {
    '5 stars' => TestimonialHelper.reviews.where((r) => r.rating == 5).toList(),
    '4 stars' => TestimonialHelper.reviews.where((r) => r.rating == 4).toList(),
    'With photos' =>
      TestimonialHelper.reviews.where((r) => r.imageAsset != null).toList(),
    'Verified' => TestimonialHelper.reviews.where((r) => r.isVerified).toList(),
    _ => TestimonialHelper.reviews,
  };

  bool get _isNarrowed => _filter != 'All';

  void _play(Testimonial review) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          title: review.quote.split('.').first,
          subtitle: '${review.author} · ${review.product}',
          url: review.videoUrl,
        ),
      ),
    );
  }

  void _toast(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _visible;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Testimonials',
              subtitle: 'Real switch stories, on video',
              onBack: () => Navigator.of(context).maybePop(),
              trailing: CircleIconButton(
                icon: Icons.rate_review_outlined,
                onTap: () => _toast('Write a review'),
                tooltip: 'Write a review',
              ),
            ),
            _FilterBar(
              filters: TestimonialHelper.filters,
              selected: _filter,
              onSelect: (f) => setState(() => _filter = f),
            ),
            Expanded(
              child: reviews.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      key: const Key('testimonials-list'),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                      itemCount: reviews.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // The summary describes the whole catalogue, so it
                          // stays put rather than reacting to the filter.
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingSummary(
                                  average: TestimonialHelper.average,
                                  total: TestimonialHelper.reviews.length,
                                  distribution: TestimonialHelper.distribution,
                                ),
                                if (_isNarrowed) ...[
                                  const SizedBox(height: 14),
                                  Text(
                                    '${reviews.length} '
                                    '${reviews.length == 1 ? 'review' : 'reviews'}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.inkFaint,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }
                        final review = reviews[index - 1];
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
      height: 58,
      child: ListView.separated(
        key: const Key('testimonial-filters'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = filter == selected;
          return Material(
            color: isActive ? AppColors.ink : AppColors.surface,
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
                    color: isActive ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.inkMuted,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined, size: 34, color: AppColors.inkFaint),
            SizedBox(height: 10),
            Text(
              'No reviews match that filter',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

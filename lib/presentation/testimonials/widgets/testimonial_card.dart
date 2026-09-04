import 'package:flutter/material.dart';
import 'package:saalt/models/testimonial.dart';
import 'package:saalt/presentation/show/widgets/episode_art.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/res/app_colors.dart';

/// A video testimonial: still frame with a play affordance and runtime, then
/// who it is, what it is about, and what they said.
class TestimonialCard extends StatelessWidget {
  const TestimonialCard({
    super.key,
    required this.review,
    this.isHelpful = false,
    this.onHelpful,
    this.onPlay,
  });

  final Testimonial review;
  final bool isHelpful;
  final VoidCallback? onHelpful;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final helpful = review.helpfulCount + (isHelpful ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Poster(review: review, onPlay: onPlay),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AuthorRow(review: review),
                const SizedBox(height: 12),
                _ProductTag(name: review.product, accent: review.avatarAccent),
                const SizedBox(height: 11),
                Text(
                  review.quote,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.hairline),
                const SizedBox(height: 6),
                _HelpfulRow(
                  count: helpful,
                  isHelpful: isHelpful,
                  onTap: onHelpful,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Still frame with the play affordance and runtime, so the card reads as a
/// clip rather than a written review.
class _Poster extends StatelessWidget {
  const _Poster({required this.review, this.onPlay});

  final Testimonial review;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final asset = review.imageAsset;

    return Semantics(
      button: true,
      label: 'Play ${review.author}’s testimonial',
      child: GestureDetector(
        onTap: onPlay,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (asset == null)
                ColoredBox(color: review.avatarTint)
              else
                Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      ColoredBox(color: review.avatarTint),
                ),
              if (review.hasVideo)
                Center(
                  child: VideoBadge(accent: review.avatarAccent, size: 48),
                ),
              if (review.minutes > 0)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${review.minutes} min',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.review});

  final Testimonial review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: review.avatarTint,
            shape: BoxShape.circle,
          ),
          child: Text(
            review.initial,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: review.avatarAccent,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      review.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  if (review.isVerified) ...[
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.sage,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  StarRating(rating: review.rating.toDouble(), size: 12),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      review.timeAgo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductTag extends StatelessWidget {
  const _ProductTag({required this.name, required this.accent});

  final String name;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_rounded, size: 11, color: accent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpfulRow extends StatelessWidget {
  const _HelpfulRow({required this.count, required this.isHelpful, this.onTap});

  final int count;
  final bool isHelpful;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isHelpful ? AppColors.rose : AppColors.inkMuted;

    return Row(
      children: [
        Expanded(
          child: Text(
            '$count found this helpful',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkFaint),
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  Icon(
                    isHelpful
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Helpful',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

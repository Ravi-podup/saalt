import 'package:flutter/material.dart';
import 'package:saalt/models/testimonial.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// A video story: the still with its play affordance, then who filmed it,
/// what it is about, and what they said.
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

  static const _avatarRing = Color(0xFFFFEDD5);
  static const _tagInk = Color(0xFFE97451);

  @override
  Widget build(BuildContext context) {
    final helpful = review.helpfulCount + (isHelpful ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Poster(review: review, onPlay: onPlay),
          const SizedBox(height: 14),
          _AuthorRow(review: review),
          const SizedBox(height: 12),
          Text(
            review.quote,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: Color(0xff2D2D2D),
            ),
          ),
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                for (final tag in review.tags)
                  Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: _tagInk,
                    ),
                  ),
              ],
            ),
          ],
          Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Divider(
              height: 1,
              color: AppColors.blackColor.withValues(alpha: .05),
            ),
          ),
          _HelpfulRow(count: helpful, onTap: onHelpful),
        ],
      ),
    );
  }
}

/// Still frame with the play affordance, so the card reads as a clip rather
/// than a written review.
class _Poster extends StatelessWidget {
  const _Poster({required this.review, this.onPlay});

  final Testimonial review;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final asset = review.imageAsset;

    return Semantics(
      button: true,
      label: 'Play ${review.author}’s story',
      child: GestureDetector(
        onTap: onPlay,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1.42,
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
                // Some stills ship with the button already drawn on them.
                if (review.hasVideo && !review.stillHasPlayBadge)
                  const Center(child: _PlayBadge()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The play control: a solid white disc inside a soft white halo, with the
/// triangle in the same #373737 the artwork uses. Sized off the still, so
/// it holds its proportions on any screen.
class _PlayBadge extends StatelessWidget {
  const _PlayBadge();

  static const _haloSize = 72.0;
  static const _discSize = 43.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _haloSize,
      width: _haloSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.28),
        shape: BoxShape.circle,
      ),
      child: Container(
        height: _discSize,
        width: _discSize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 32,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

/// Who filmed it: their disc, their name with the verified mark, and the
/// product the story is about.
class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.review});

  final Testimonial review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: review.avatarTint,
            shape: BoxShape.circle,
            border: Border.all(color: TestimonialCard._avatarRing, width: 1.5),
          ),
          child: Text(
            review.initial,
            style: TextStyle(
              fontSize: 20,
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
                        fontWeight: FontWeight.w500,
                        // letterSpacing: -0.2,
                        color: Color(0xff2D2D2D),
                      ),
                    ),
                  ),
                  if (review.isVerified) ...[
                    const SizedBox(width: 6),
                    Image.asset(
                      AppImages.checkCircleIcon,
                      height: 14,
                      width: 14,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${review.timeAgo} · ${review.product}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff717171),
                      ),
                    ),
                  ),
                  if (review.productIcon != null) ...[
                    const SizedBox(width: 6),
                    Image.asset(
                      review.productIcon!,
                      height: 11,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The one thing you can do to a story: say it helped. The count beside it
/// speaks for everyone else.
class _HelpfulRow extends StatelessWidget {
  const _HelpfulRow({required this.count, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.likeCircleIcon,
                height: 20,
                width: 20,
                errorBuilder: (_, _, _) => const SizedBox(width: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Helpful',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkDeep,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          '$count found this helpful',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff717171),
          ),
        ),
      ],
    );
  }
}

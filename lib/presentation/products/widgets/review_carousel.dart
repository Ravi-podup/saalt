import 'package:flutter/material.dart';
import 'package:saalt/models/review_quote.dart';
import 'package:saalt/res/app_colors.dart';

/// Swipeable pull-quote reviews, centred like the site's slider. The desktop
/// version uses side arrows and a pause button; on a phone a swipe plus page
/// dots does the same job without the chrome.
class ReviewCarousel extends StatefulWidget {
  const ReviewCarousel({super.key, required this.reviews, this.onReadMore});

  final List<ReviewQuote> reviews;
  final VoidCallback? onReadMore;

  @override
  State<ReviewCarousel> createState() => _ReviewCarouselState();
}

class _ReviewCarouselState extends State<ReviewCarousel> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 224,
          child: PageView.builder(
            key: const Key('review-carousel'),
            controller: _controller,
            itemCount: widget.reviews.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) =>
                _Slide(review: widget.reviews[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.reviews.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: i == _page ? 18 : 6,
                decoration: BoxDecoration(
                  color: i == _page ? AppColors.rose : AppColors.hairline,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Semantics(
          button: true,
          child: GestureDetector(
            onTap: widget.onReadMore,
            behavior: HitTestBehavior.opaque,
            child: const Text(
              'Read more reviews',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.review});

  final ReviewQuote review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < review.stars; i++)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.5),
                  child: Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.ink,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.product,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '“'),
                  TextSpan(text: review.lead),
                  TextSpan(
                    text: review.emphasis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: '”'),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '– ${review.author}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

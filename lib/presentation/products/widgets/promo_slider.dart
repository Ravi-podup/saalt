import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Brand banner slider for the top of the shop. Swipe-driven, matching the
/// episode carousel, with page dots beneath.
class PromoSlider extends StatefulWidget {
  const PromoSlider({super.key, required this.images, this.onTap});

  final List<String> images;

  /// Receives the index of the tapped banner.
  final ValueChanged<int>? onTap;

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
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
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView.builder(
              key: const Key('promo-slider'),
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => widget.onTap?.call(index),
                child: Image.asset(
                  widget.images[index],
                  fit: BoxFit.cover,
                  // These banners put faces near the top, and one of them is
                  // portrait, so anchoring to the top keeps heads in frame.
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) =>
                      const ColoredBox(color: AppColors.hairline),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.images.length; i++)
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
      ],
    );
  }
}

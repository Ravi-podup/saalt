import 'package:flutter/material.dart';
import 'package:saalt/res/app_images.dart';

/// What Cherie is pointing at this week. The name and the button are printed
/// into each picture, so the slider draws nothing but the picture and dots.
class RecommendationSlider extends StatefulWidget {
  const RecommendationSlider({super.key, required this.images, this.onTap});

  final List<String> images;

  /// Receives the index of the tapped picture.
  final ValueChanged<int>? onTap;

  @override
  State<RecommendationSlider> createState() => _RecommendationSliderState();
}

class _RecommendationSliderState extends State<RecommendationSlider> {
  late final PageController _controller;
  int _page = 0;

  static const _activeDot = Color(0xFFC95878);
  static const _restingDot = Color(0xFFCBD5E1);

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
    return AspectRatio(
      aspectRatio: 1.14,
      child: Stack(
        children: [
          PageView.builder(
            key: const Key('recommendation-slider'),
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => widget.onTap?.call(index),
              child: Image.asset(
                widget.images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: Color(0xFFE7E3DE)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.images.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 7,
                    width: i == _page ? 20 : 7,
                    decoration: BoxDecoration(
                      color: i == _page ? _activeDot : _restingDot,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The pictures the slider runs, in order.
const recommendationImages = <String>[
  AppImages.hankyPankyImg,
  "assets/images/recommand1_img.png",
  "assets/images/recommand2_img.png",
];

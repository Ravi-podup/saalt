import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Editorial panel for the underwear line. The site runs it side by side;
/// on a phone the image stacks above the copy so neither gets squeezed.
class WhySaaltWear extends StatelessWidget {
  const WhySaaltWear({
    super.key,
    required this.imageAsset,
    this.onShop,
    this.onPlay,
  });

  final String imageAsset;
  final VoidCallback? onShop;

  /// The still is a video frame, so it carries a play button.
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiteColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              _PlayButton(onTap: onPlay),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why Saalt Wear?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Saalt Wear is the thinnest, driest, and most comfortable leakproof period underwear with patented gusset technology.',
                style: TextStyle(
                  fontSize: 13,
                  // height: 1.45,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3F4759),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The play control over the still: a white disc inside a soft halo, so it
/// reads on a light frame as well as a dark one.
class _PlayButton extends StatelessWidget {
  const _PlayButton({this.onTap});

  final VoidCallback? onTap;

  static const _haloSize = 80.0;
  static const _discSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _haloSize,
      width: _haloSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.26),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            height: _discSize,
            width: _discSize,
            child: Icon(
              Icons.play_arrow_rounded,
              size: 34,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

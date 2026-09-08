import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Editorial panel for the underwear line. The site runs it side by side;
/// on a phone the image stacks above the copy so neither gets squeezed.
class WhySaaltWear extends StatelessWidget {
  const WhySaaltWear({super.key, required this.imageAsset, this.onShop});

  final String imageAsset;
  final VoidCallback? onShop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              // The source carries its own caption near the bottom; anchoring
              // to the top crops that out and keeps the fabric detail.
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: AppColors.apricotTint),
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.apricotTint,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why Saalt Wear?',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The thinnest, driest and most comfortable leakproof period '
                  'underwear — with patented gusset technology.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: onShop,
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 13,
                      ),
                      child: Text(
                        'SHOP SAALT WEAR',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

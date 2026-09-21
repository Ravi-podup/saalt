import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// The foot of the shop: where the brand is, and what it takes payment with.
class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key, this.onFollow});

  final VoidCallback? onFollow;

  static const _bodyInk = Color(0xFF3F4759);
  static const _shopPurple = Color(0xFF5A31F4);

  static const _socials = <String>[
    AppImages.facebookIcon,
    AppImages.instagramIcon,
    AppImages.youtubeIcon,
    AppImages.tikTokIcon,
    AppImages.pinterestIcon,
  ];

  static const _payments = <String>[
    AppImages.amexPayIcon,
    AppImages.applePayIcon,
    AppImages.dinersClubPayIcon,
    AppImages.discoverPayIcon,
    AppImages.googlePayIcon,
    AppImages.mastercardPayIcon,
    AppImages.paypalPayIcon,
    AppImages.shopPayIcon,
    AppImages.venmoPayIcon,
    AppImages.visaPayIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '@saaltco',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.5,
            color: Color(0xff444445),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'We openly talk about periods to break taboos and educate. Join '
          'the conversation to bring uteruses out of the dark ages.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: Color(0xff373737),
          ),
        ),
        const SizedBox(height: 25),
        // Wrapped, not a Row: five discs and the Shop pill are wider than a
        // phone, so the pill drops to its own line when it has to.
        Wrap(
          spacing: 10,
          runSpacing: 19,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final social in _socials) _SocialDisc(asset: social),
            _FollowButton(onTap: onFollow),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'SECURE PAYMENT METHODS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
            color: Color(0xff474747),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: [
            for (final mark in _payments)
              Image.asset(
                mark,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
          ],
        ),
      ],
    );
  }
}

class _SocialDisc extends StatelessWidget {
  const _SocialDisc({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: Center(
          child: Image.asset(asset, height: 14, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Color(0xff5433EB),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.followIcon, height: 18),
            const SizedBox(width: 8),
            const Text(
              'Follow on Shop',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

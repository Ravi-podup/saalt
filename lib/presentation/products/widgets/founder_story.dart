import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class FounderStory extends StatelessWidget {
  const FounderStory({super.key, this.onWatch});

  /// Plays the film. The still is the only control the section has.
  final VoidCallback? onWatch;

  static const _quote =
      '"I started Saalt in 2018 to help my aunt in Venezuela. Now tens of '
      'thousands of people have a better period every month in 50 countries."';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Film(onPlay: onWatch),
        const SizedBox(height: 22),
        Image.asset(
          AppImages.quotsGrayImg,
          height: 22,
          color: Color(0xffADADAD),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        const Text(
          _quote,
          style: TextStyle(
            fontSize: 17,
            height: 1.5,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 22),
        // The short rule the layout puts between quote and attribution.
        Container(width: 44, height: 2, color: const Color(0xFFC4704A)),
        const SizedBox(height: 21),
        const _Attribution(),
        const SizedBox(height: 22),
        const _Certifications(),
      ],
    );
  }
}

class _Film extends StatelessWidget {
  const _Film({this.onPlay});

  final VoidCallback? onPlay;

  // static const _maxHeight = 260.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play the founder’s story',
      child: GestureDetector(
        onTap: onPlay,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppImages.leftImg,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const _PlayBadge(),
              const Positioned(right: 14, bottom: 14, child: _ReachBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

/// How far the brand reaches, tucked into the corner of the still.
class _ReachBadge extends StatelessWidget {
  const _ReachBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF0E8DF),
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImages.worldIcon, height: 15),
          ),
          const SizedBox(width: 9),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '50+ Countries',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2420),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Worldwide reach',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF9A8F87)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A solid white disc inside a soft halo. Same control as the one on a story
/// card, so a film reads the same wherever it appears.
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

/// Who said it: her face, her name, and the two things that place her.
class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            AppImages.profileGirlImg,
            height: 46,
            width: 46,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHERIE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2C2420),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF5EE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 6,
                          width: 6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Co-Founder, Saalt',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff6B7A65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Mother of five daughters',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff374151),
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

class _Certifications extends StatelessWidget {
  const _Certifications();

  static const _marks = <String>[
    AppImages.certifiedImg,
    AppImages.certifiedPlasticImg,
    AppImages.certifiedWbencImg,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 53),
      child: Row(
        children: [
          for (final mark in _marks)
            Padding(
              padding: EdgeInsets.only(
                right: mark == AppImages.certifiedPlasticImg ? 0 : 14,
              ),
              child: Image.asset(
                mark,
                height: mark == AppImages.certifiedWbencImg ? 35 : 45,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(height: 34),
              ),
            ),
        ],
      ),
    );
  }
}

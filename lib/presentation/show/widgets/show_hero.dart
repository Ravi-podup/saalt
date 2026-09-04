import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Opening panel: what the show is, and the two things you can do about it.
class ShowHero extends StatelessWidget {
  const ShowHero({super.key, this.onSubscribe, this.onEpisodes});

  final VoidCallback? onSubscribe;
  final VoidCallback? onEpisodes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A5468),
            AppColors.primaryColor,
            Color(0xFF343B4A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.26),
            blurRadius: 22,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.roseTint.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'PERIODS & WOMEN’S HEALTH',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.roseTint,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Real answers from real\nsources — periods to\nperimenopause',
            style: TextStyle(
              fontSize: 22,
              height: 1.22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Every week: expert interviews, honest customer stories and '
            'community roundtables. No TMI filter.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: Colors.white.withValues(alpha: 0.66),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              // Share the width so long labels cannot overflow the panel.
              Expanded(
                child: _Cta(
                  label: 'Subscribe',
                  icon: Icons.add_rounded,
                  isPrimary: true,
                  onTap: onSubscribe,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Cta(
                  label: 'Episodes',
                  icon: Icons.play_arrow_rounded,
                  onTap: onEpisodes,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cta extends StatelessWidget {
  const _Cta({
    required this.label,
    required this.icon,
    this.isPrimary = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? AppColors.primaryColor : Colors.white;

    return Material(
      color: isPrimary ? Colors.white : Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: foreground,
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

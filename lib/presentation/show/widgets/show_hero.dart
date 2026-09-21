import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Opening panel: what the show is, and the two things you can do about it.
/// Sits on the same artwork as the tracker card on the dashboard.
class ShowHero extends StatelessWidget {
  const ShowHero({super.key, this.onSubscribe, this.onEpisodes});

  final VoidCallback? onSubscribe;
  final VoidCallback? onEpisodes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(AppImages.periodTrackerBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.waterDropIcon,
                  height: 20,
                  width: 10,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Period & Women’s Health',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFDFBF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Real answer from real\nsources - periods to perimenopause',
            style: TextStyle(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: Color(0xffFDFBF6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Every week: expert interviews, customer stories and The Saalt '
            'Collective roundtables.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _SubscribeButton(onTap: onSubscribe)),
              const SizedBox(width: 10),
              Expanded(child: _EpisodesButton(onTap: onEpisodes)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.addIcon, height: 10, width: 10),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'SUBSCRIBE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkDeep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EpisodesButton extends StatelessWidget {
  const _EpisodesButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, size: 15, color: Colors.white),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'EPISODES',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

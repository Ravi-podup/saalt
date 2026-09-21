import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class PeriodTrackerCard extends StatelessWidget {
  const PeriodTrackerCard({
    super.key,
    required this.cycleDay,
    required this.cycleLength,
    required this.phaseLabel,
    this.onTap,
    this.onLogTap,
    this.onFitQuizTap,
  });

  final int cycleDay;
  final int cycleLength;
  final String phaseLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLogTap;
  final VoidCallback? onFitQuizTap;

  @override
  Widget build(BuildContext context) {
    final progress = (cycleDay / cycleLength).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage(AppImages.periodTrackerBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                        Flexible(
                          child: Text(
                            'Period Tracker',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffFDFBF6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      phaseLabel,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFDFBF6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Next period in 14 days',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _CycleRing(progress: progress, cycleDay: cycleDay),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _LogButton(onTap: onLogTap),
              const SizedBox(width: 10),
              Expanded(child: FitQuizButton(onTap: onFitQuizTap)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogButton extends StatelessWidget {
  const _LogButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.addIcon, height: 10, width: 10),
            const SizedBox(width: 6),
            const Flexible(
              child: Text(
                'LOG TODAY',
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

class FitQuizButton extends StatelessWidget {
  final VoidCallback? onTap;
  const FitQuizButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TAKE THE FIT QUIZ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(width: 3),
            Image.asset(AppImages.forwardIcon, height: 10),
          ],
        ),
      ),
    );
  }
}

class _CycleRing extends StatelessWidget {
  const _CycleRing({required this.progress, required this.cycleDay});

  final double progress;
  final int cycleDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      width: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              backgroundColor: Color(0xff423B38),
              valueColor: const AlwaysStoppedAnimation(Color(0xffF4ECE4)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$cycleDay',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFDFBF6),
                ),
              ),
              Text(
                "Day's",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.whiteColor.withValues(alpha: .7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

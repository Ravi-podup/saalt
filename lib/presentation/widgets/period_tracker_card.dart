import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

class PeriodTrackerCard extends StatelessWidget {
  const PeriodTrackerCard({
    super.key,
    required this.cycleDay,
    required this.cycleLength,
    required this.phaseLabel,
    this.onTap,
    this.onLogTap,
  });

  final int cycleDay;
  final int cycleLength;
  final String phaseLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLogTap;

  @override
  Widget build(BuildContext context) {
    final progress = (cycleDay / cycleLength).clamp(0.0, 1.0);
    final daysLeft = (cycleLength - cycleDay).clamp(0, cycleLength);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
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
                color: AppColors.primaryColor.withValues(alpha: 0.28),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: AppColors.roseTint.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            size: 14,
                            color: AppColors.roseTint,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Period Tracker',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      phaseLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      daysLeft == 0
                          ? 'Your next period is expected today'
                          : 'Next period in $daysLeft ${daysLeft == 1 ? 'day' : 'days'}',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LogButton(onTap: onLogTap),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _CycleRing(progress: progress, cycleDay: cycleDay),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogButton extends StatelessWidget {
  const _LogButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: AppColors.primaryColor),
              SizedBox(width: 6),
              Text(
                'Log today',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
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
      height: 104,
      width: 104,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.14),
              valueColor: const AlwaysStoppedAnimation(AppColors.roseTint),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DAY',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
              Text(
                '$cycleDay',
                style: const TextStyle(
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

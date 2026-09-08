import 'package:flutter/material.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/res/app_colors.dart';

/// The one thing a tracker must answer on open: where am I, and when is the
/// next period?
class CycleStatusCard extends StatelessWidget {
  const CycleStatusCard({
    super.key,
    required this.cycleDay,
    required this.cycleLength,
    required this.phase,
    required this.daysUntilNextPeriod,
    this.headline,
    this.detail,
    this.onLog,
  });

  final int cycleDay;
  final int cycleLength;
  final CyclePhase phase;
  final int daysUntilNextPeriod;

  /// Overrides the countdown, for a day other than today.
  final String? headline;

  /// Overrides the phase blurb. A day in the future has not bled yet, so
  /// "Bleeding" would be a statement about something that has not happened.
  final String? detail;

  /// When null the card drops its button, for screens that carry the log form
  /// directly underneath.
  final VoidCallback? onLog;

  @override
  Widget build(BuildContext context) {
    final progress = (cycleDay / cycleLength).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.roseTint,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headline ??
                      (daysUntilNextPeriod <= 0
                          ? 'Period expected today'
                          : 'Period in $daysUntilNextPeriod '
                                '${daysUntilNextPeriod == 1 ? 'day' : 'days'}'),
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  detail ?? phase.blurb,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.62),
                  ),
                ),
                if (onLog != null) ...[
                  const SizedBox(height: 16),
                  _LogButton(onTap: onLog),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Ring(progress: progress, cycleDay: cycleDay),
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
                  fontWeight: FontWeight.w700,
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

class _Ring extends StatelessWidget {
  const _Ring({required this.progress, required this.cycleDay});

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

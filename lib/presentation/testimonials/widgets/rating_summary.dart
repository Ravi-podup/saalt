import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/res/app_colors.dart';

/// Aggregate score and star breakdown at the top of the reviews list.
class RatingSummary extends StatelessWidget {
  const RatingSummary({
    super.key,
    required this.average,
    required this.total,
    required this.distribution,
  });

  final double average;
  final int total;

  /// Star level (5 down to 1) mapped to how many reviews sit there.
  final Map<int, int> distribution;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 38,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 7),
              StarRating(rating: average, size: 14),
              const SizedBox(height: 6),
              Text(
                '$total reviews',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                for (final entry in distribution.entries)
                  _DistributionRow(
                    star: entry.key,
                    count: entry.value,
                    total: total,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({
    required this.star,
    required this.count,
    required this.total,
  });

  final int star;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              '$star',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          const Icon(Icons.star_rounded, size: 11, color: AppColors.rose),
          const SizedBox(width: 7),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.hairline,
                valueColor: const AlwaysStoppedAnimation(AppColors.rose),
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: AppColors.inkFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

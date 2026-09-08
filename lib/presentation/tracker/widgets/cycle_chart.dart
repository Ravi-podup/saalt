import 'package:flutter/material.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/res/app_colors.dart';

/// Cycle history as a bar chart: one bar per recorded cycle, oldest on the
/// left, with the bleeding days drawn solid at the base of each bar so period
/// length and cycle length can be read from the same shape.
class CycleChart extends StatelessWidget {
  const CycleChart({
    super.key,
    required this.cycles,
    required this.averageCycle,
    required this.averagePeriod,
  });

  /// Newest first, the way the history is stored. Drawn oldest first.
  final List<CycleLog> cycles;

  final int averageCycle;
  final int averagePeriod;

  /// Height of the plot itself, excluding the value labels above the bars and
  /// the date labels below them.
  static const _plotHeight = 148.0;
  static const _valueLabelHeight = 18.0;

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final ordered = cycles.reversed.toList();
    final longest = ordered
        .map((c) => c.cycleLength)
        .reduce((a, b) => a > b ? a : b);
    // Headroom above the tallest bar, so the value label never crowds the top
    // of the plot and the average line stays inside the axis.
    final scale = (longest + 4).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last ${ordered.length} cycles',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bar height is the whole cycle; the solid base is bleeding.',
            style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: _plotHeight + _valueLabelHeight,
            child: Stack(
              children: [
                // The average sits behind the bars so a bar never hides it.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: _plotHeight * (averageCycle / scale),
                  child: const _AverageLine(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < ordered.length; i++)
                      Expanded(
                        child: _Bar(
                          // Keyed by position so a test can measure that bar
                          // heights track the cycle lengths.
                          barKey: Key('cycle-bar-$i'),
                          cycle: ordered[i],
                          scale: scale,
                          plotHeight: _plotHeight,
                          labelHeight: _valueLabelHeight,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final cycle in ordered)
                Expanded(
                  child: Text(
                    _startLabel(cycle),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.hairline, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const _Key(color: AppColors.rose, label: 'Bleeding'),
              const SizedBox(width: 14),
              const _Key(color: AppColors.roseTint, label: 'Rest of cycle'),
              const Spacer(),
              Flexible(
                child: Text(
                  'avg $averageCycle d',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkFaint,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _startLabel(CycleLog cycle) {
    final d = cycle.startDate;
    return '${d.day} ${_monthNames[d.month - 1]}';
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.barKey,
    required this.cycle,
    required this.scale,
    required this.plotHeight,
    required this.labelHeight,
  });

  final Key barKey;
  final CycleLog cycle;
  final double scale;
  final double plotHeight;
  final double labelHeight;

  @override
  Widget build(BuildContext context) {
    final height = plotHeight * (cycle.cycleLength / scale);
    // Bleeding days keep their true share of the bar, so a long period on a
    // short cycle reads as the bigger block it is.
    final bleeding = height * (cycle.periodLength / cycle.cycleLength);

    return Semantics(
      label:
          '${cycle.cycleLength} day cycle, '
          '${cycle.periodLength} days bleeding',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: labelHeight,
              child: Center(
                // Carries the card colour so the average rule breaks around
                // the number instead of striking through it.
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    '${cycle.cycleLength}',
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              key: barKey,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: Radius.circular(3),
              ),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(child: Container(color: AppColors.roseTint)),
                    Container(height: bleeding, color: AppColors.rose),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dotted rule marking the average cycle length.
class _AverageLine extends StatelessWidget {
  const _AverageLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 4.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          children: [
            for (var i = 0; i < count; i++)
              Container(
                width: dash,
                height: 1,
                margin: const EdgeInsets.only(right: gap),
                color: AppColors.inkFaint.withValues(alpha: 0.45),
              ),
          ],
        );
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 9,
          width: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Month grid marking recorded bleeding, the predicted next period, the
/// fertile window and today. This is the view people actually open a tracker
/// for, so it carries a legend rather than leaving the colours to guesswork.
class CycleCalendar extends StatelessWidget {
  const CycleCalendar({
    super.key,
    required this.month,
    required this.periodDays,
    required this.predictedDays,
    required this.fertileDays,
  });

  final DateTime month;

  /// Days already bled, as day-of-month numbers.
  final Set<int> periodDays;

  /// Days the next period is predicted to fall on.
  final Set<int> predictedDays;

  final Set<int> fertileDays;

  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Dart weekday is 1=Mon..7=Sun, which already matches the header.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final now = DateTime.now();
    final todayNumber = now.year == month.year && now.month == month.month
        ? now.day
        : -1;

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
            _monthName(month),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final day in _weekdays)
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              return _DayCell(
                day: day,
                isToday: day == todayNumber,
                isPeriod: periodDays.contains(day),
                isPredicted: predictedDays.contains(day),
                isFertile: fertileDays.contains(day),
              );
            },
          ),
          const SizedBox(height: 12),
          const _Legend(),
        ],
      ),
    );
  }

  static String _monthName(DateTime d) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[d.month - 1]} ${d.year}';
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isPeriod,
    required this.isPredicted,
    required this.isFertile,
  });

  final int day;
  final bool isToday;
  final bool isPeriod;
  final bool isPredicted;
  final bool isFertile;

  @override
  Widget build(BuildContext context) {
    Color background = Colors.transparent;
    Color foreground = AppColors.ink;
    Border? border;

    if (isPeriod) {
      background = AppColors.rose;
      foreground = Colors.white;
    } else if (isPredicted) {
      // Dashed-style distinction is not worth the paint cost; an outline in
      // the same hue reads as "expected, not recorded".
      border = Border.all(color: AppColors.rose, width: 1.4);
      foreground = AppColors.rose;
    } else if (isFertile) {
      background = AppColors.tealTint;
      foreground = AppColors.teal;
    }

    return Semantics(
      label: _label(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: border,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                color: foreground,
              ),
            ),
            if (isToday)
              Positioned(
                bottom: 3,
                child: Container(
                  height: 3,
                  width: 3,
                  decoration: BoxDecoration(
                    color: isPeriod ? Colors.white : AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _label() {
    if (isPeriod) return 'Day $day, period';
    if (isPredicted) return 'Day $day, period expected';
    if (isFertile) return 'Day $day, fertile window';
    return 'Day $day';
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _LegendItem(color: AppColors.rose, label: 'Period'),
        _LegendItem(color: AppColors.rose, label: 'Expected', outlined: true),
        _LegendItem(color: AppColors.tealTint, label: 'Fertile'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.outlined = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : color,
            border: outlined ? Border.all(color: color, width: 1.4) : null,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}

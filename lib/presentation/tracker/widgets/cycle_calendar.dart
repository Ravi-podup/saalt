import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Month grid marking recorded bleeding, expected periods, the fertile window
/// and today. Days are tappable: this is the way into a single day's entry.
class CycleCalendar extends StatelessWidget {
  const CycleCalendar({
    super.key,
    required this.month,
    required this.periodDays,
    required this.predictedDays,
    required this.fertileDays,
    this.loggedDays = const {},
    this.onDayTap,
    this.onPreviousMonth,
    this.onNextMonth,
    this.weekStartsOnSunday = false,
  });

  final DateTime month;

  /// Days already bled, as day-of-month numbers.
  final Set<int> periodDays;

  /// Days a period is predicted to fall on.
  final Set<int> predictedDays;

  final Set<int> fertileDays;

  /// Days with something logged against them, marked so the month shows where
  /// the entries are rather than hiding them a tap deep.
  final Set<int> loggedDays;

  /// Called with the day of the month that was tapped.
  final ValueChanged<int>? onDayTap;

  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  /// Sunday-first calendars are the norm in the US, Monday-first elsewhere.
  final bool weekStartsOnSunday;

  static const _mondayFirst = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _sundayFirst = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static const _monthNames = [
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

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Dart weekday is 1=Mon..7=Sun. Monday-first is already that order;
    // Sunday-first wraps Sunday round to the front.
    final leadingBlanks = weekStartsOnSunday
        ? firstOfMonth.weekday % 7
        : firstOfMonth.weekday - 1;
    final weekdays = weekStartsOnSunday ? _sundayFirst : _mondayFirst;
    final now = DateTime.now();
    final todayNumber = now.year == month.year && now.month == month.month
        ? now.day
        : -1;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthBar(
            label: monthLabel(month),
            onPrevious: onPreviousMonth,
            onNext: onNextMonth,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final day in weekdays)
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            key: const Key('calendar-grid'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
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
                isLogged: loggedDays.contains(day),
                onTap: onDayTap == null ? null : () => onDayTap!(day),
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.hairline, height: 1),
          const SizedBox(height: 12),
          _Legend(showLogged: loggedDays.isNotEmpty),
        ],
      ),
    );
  }

  static String monthLabel(DateTime d) =>
      '${_monthNames[d.month - 1]} ${d.year}';
}

class _MonthBar extends StatelessWidget {
  const _MonthBar({required this.label, this.onPrevious, this.onNext});

  final String label;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Arrow(
          icon: Icons.chevron_left_rounded,
          tooltip: 'Previous month',
          onTap: onPrevious,
        ),
        Expanded(
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.ink,
            ),
          ),
        ),
        _Arrow(
          icon: Icons.chevron_right_rounded,
          tooltip: 'Next month',
          onTap: onNext,
        ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.canvas,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 32,
            width: 32,
            child: Icon(icon, size: 20, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isPeriod,
    required this.isPredicted,
    required this.isFertile,
    required this.isLogged,
    this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isPeriod;
  final bool isPredicted;
  final bool isFertile;
  final bool isLogged;
  final VoidCallback? onTap;

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
      button: onTap != null,
      child: Material(
        color: background,
        shape: border == null
            ? const CircleBorder()
            : CircleBorder(side: border.top),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                  color: foreground,
                ),
              ),
              if (isLogged)
                Positioned(
                  // Inside the ring an expected day draws, not on top of it.
                  top: 6,
                  right: 7,
                  child: Container(
                    height: 4.5,
                    width: 4.5,
                    decoration: BoxDecoration(
                      color: isPeriod ? Colors.white : AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (isToday)
                Positioned(
                  bottom: 4,
                  child: Container(
                    height: 3.5,
                    width: 3.5,
                    decoration: BoxDecoration(
                      color: isPeriod ? Colors.white : AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _label() {
    final logged = isLogged ? ', logged' : '';
    if (isPeriod) return 'Day $day, period$logged';
    if (isPredicted) return 'Day $day, period expected$logged';
    if (isFertile) return 'Day $day, fertile window$logged';
    return 'Day $day$logged';
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.showLogged});

  /// The logged key only earns its space once something is logged.
  final bool showLogged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        const _LegendItem(color: AppColors.rose, label: 'Period'),
        const _LegendItem(
          color: AppColors.rose,
          label: 'Expected',
          outlined: true,
        ),
        const _LegendItem(color: AppColors.tealTint, label: 'Fertile'),
        if (showLogged)
          const _LegendItem(color: AppColors.ink, label: 'Logged', dot: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.outlined = false,
    this.dot = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  /// Drawn at marker size rather than day size, matching how it appears in
  /// the grid.
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
          width: 10,
          child: Center(
            child: Container(
              height: dot ? 4.5 : 10,
              width: dot ? 4.5 : 10,
              decoration: BoxDecoration(
                color: outlined ? Colors.transparent : color,
                border: outlined ? Border.all(color: color, width: 1.4) : null,
                shape: BoxShape.circle,
              ),
            ),
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

import 'package:flutter/material.dart';
import 'package:saalt/helper/entry_store.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/presentation/tracker/day_detail_screen.dart';
import 'package:saalt/presentation/tracker/tracker_settings_screen.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_calendar.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';

/// Step one of the tracker: the calendar, and nothing competing with it.
/// Tapping a day opens [DayDetailScreen], which carries that day's entry and
/// the cycle statistics.
class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  /// First of the month on show. Kept normalised so month arithmetic cannot
  /// skip a month from a 31st.
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  void _shiftMonth(int by) {
    setState(() => _month = DateTime(_month.year, _month.month + by));
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() => _month = DateTime(now.year, now.month));
  }

  void _openDay(int dayOfMonth) {
    _openDate(DateTime(_month.year, _month.month, dayOfMonth));
  }

  void _openDate(DateTime date) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DayDetailScreen(date: date)));
  }

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TrackerSettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Period Tracker',
              onBack: () => Navigator.of(context).maybePop(),
              trailing: Row(
                children: [
                  if (!_isCurrentMonth) ...[
                    CircleIconButton(
                      icon: Icons.today_rounded,
                      tooltip: 'Back to this month',
                      onTap: _goToToday,
                    ),
                    const SizedBox(width: 8),
                  ],
                  CircleIconButton(
                    icon: Icons.tune_rounded,
                    tooltip: 'Tracker settings',
                    onTap: _openSettings,
                  ),
                ],
              ),
            ),
            Expanded(
              // Settings change the cycle lengths and the week start, and
              // logging a day adds a marker, so the calendar rebuilds on both
              // stores rather than reading them once.
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  TrackerSettings.prefs,
                  EntryStore.entries,
                ]),
                builder: (context, _) {
                  final logged = EntryStore.loggedDaysIn(_month);
                  return ListView(
                    key: const Key('tracker-body'),
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                    children: [
                      _TodayStrip(onTap: () => _openDate(DateTime.now())),
                      const SizedBox(height: 16),
                      CycleCalendar(
                        month: _month,
                        periodDays: TrackerHelper.periodDaysIn(_month),
                        predictedDays: TrackerHelper.predictedDaysIn(_month),
                        fertileDays: TrackerHelper.fertileDaysIn(_month),
                        loggedDays: logged,
                        weekStartsOnSunday:
                            TrackerSettings.current.weekStartsOnSunday,
                        onDayTap: _openDay,
                        onPreviousMonth: () => _shiftMonth(-1),
                        onNextMonth: () => _shiftMonth(1),
                      ),
                      const SizedBox(height: 14),
                      _Hint(loggedThisMonth: logged.length),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where the cycle is right now. Deliberately one line tall: the calendar is
/// what this screen is for.
class _TodayStrip extends StatelessWidget {
  const _TodayStrip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.roseTint,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.rose,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${TrackerHelper.cycleDay}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cycle day ${TrackerHelper.cycleDay} · '
                      '${TrackerHelper.phase.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      TrackerHelper.statusLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.loggedThisMonth});

  final int loggedThisMonth;

  @override
  Widget build(BuildContext context) {
    final text = loggedThisMonth == 0
        ? 'Tap any day to log it and see your cycle statistics.'
        : '$loggedThisMonth ${loggedThisMonth == 1 ? 'day' : 'days'} logged '
              'this month. Tap any day to add or change it.';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          loggedThisMonth == 0
              ? Icons.touch_app_outlined
              : Icons.check_circle_outline_rounded,
          size: 13,
          color: AppColors.inkFaint,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.4,
              color: AppColors.inkFaint,
            ),
          ),
        ),
      ],
    );
  }
}

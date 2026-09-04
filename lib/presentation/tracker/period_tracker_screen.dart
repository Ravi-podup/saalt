import 'package:flutter/material.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_calendar.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_status_card.dart';
import 'package:saalt/presentation/tracker/widgets/log_today_card.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  String? _flow;
  String? _mood;
  final _symptoms = <String>{};
  bool _isSaved = false;

  final _logKey = GlobalKey();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLog() {
    final context = _logKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      alignment: 0.1,
    );
  }

  void _save() {
    setState(() => _isSaved = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Today’s entry saved'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  /// Day-of-month sets for the calendar, derived from the recorded cycles and
  /// the prediction rather than hardcoded.
  ({Set<int> period, Set<int> predicted, Set<int> fertile}) _calendarMarks() {
    final now = DateTime.now();
    final period = <int>{};
    final predicted = <int>{};
    final fertile = <int>{};

    bool sameMonth(DateTime d) => d.year == now.year && d.month == now.month;

    for (final cycle in TrackerHelper.history) {
      for (var i = 0; i < cycle.periodLength; i++) {
        final day = cycle.startDate.add(Duration(days: i));
        if (sameMonth(day)) period.add(day.day);
      }
    }

    final next = TrackerHelper.nextPeriodStart;
    for (var i = 0; i < TrackerHelper.averagePeriod; i++) {
      final day = next.add(Duration(days: i));
      if (sameMonth(day)) predicted.add(day.day);
    }

    final start = TrackerHelper.current.startDate;
    for (var d = 1; d <= TrackerHelper.averageCycle; d++) {
      if (!TrackerHelper.isFertile(d)) continue;
      final day = start.add(Duration(days: d - 1));
      if (sameMonth(day) && !period.contains(day.day)) fertile.add(day.day);
    }

    return (period: period, predicted: predicted, fertile: fertile);
  }

  @override
  Widget build(BuildContext context) {
    final marks = _calendarMarks();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Period Tracker',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('tracker-body'),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                children: [
                  CycleStatusCard(
                    cycleDay: TrackerHelper.cycleDay,
                    cycleLength: TrackerHelper.averageCycle,
                    phase: TrackerHelper.phase,
                    daysUntilNextPeriod: TrackerHelper.daysUntilNextPeriod,
                    onLog: _scrollToLog,
                  ),
                  const SizedBox(height: 22),
                  const _SectionLabel('This month'),
                  const SizedBox(height: 12),
                  CycleCalendar(
                    month: DateTime.now(),
                    periodDays: marks.period,
                    predictedDays: marks.predicted,
                    fertileDays: marks.fertile,
                  ),
                  const SizedBox(height: 22),
                  const _SectionLabel('Your averages'),
                  const SizedBox(height: 12),
                  const _Averages(),
                  const SizedBox(height: 22),
                  _SectionLabel('Log today', key: _logKey),
                  const SizedBox(height: 12),
                  LogTodayCard(
                    flow: _flow,
                    symptoms: _symptoms,
                    mood: _mood,
                    isSaved: _isSaved,
                    onFlow: (v) => setState(() {
                      _flow = _flow == v ? null : v;
                      _isSaved = false;
                    }),
                    onSymptom: (v) => setState(() {
                      _symptoms.contains(v)
                          ? _symptoms.remove(v)
                          : _symptoms.add(v);
                      _isSaved = false;
                    }),
                    onMood: (v) => setState(() {
                      _mood = _mood == v ? null : v;
                      _isSaved = false;
                    }),
                    onSave: _save,
                  ),
                  const SizedBox(height: 22),
                  const _SectionLabel('Recent cycles'),
                  const SizedBox(height: 12),
                  for (final cycle in TrackerHelper.history) ...[
                    _CycleRow(cycle: cycle),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 10),
                  const _Disclaimer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Averages extends StatelessWidget {
  const _Averages();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(
          value: '${TrackerHelper.averageCycle}',
          unit: 'days',
          label: 'Cycle',
          accent: AppColors.rose,
        ),
        const SizedBox(width: 10),
        _Stat(
          value: '${TrackerHelper.averagePeriod}',
          unit: 'days',
          label: 'Period',
          accent: AppColors.periwinkle,
        ),
        const SizedBox(width: 10),
        _Stat(
          value: '±${TrackerHelper.variability}',
          unit: 'days',
          label: 'Variation',
          accent: AppColors.teal,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.unit,
    required this.label,
    required this.accent,
  });

  final String value;
  final String unit;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    unit,
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
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleRow extends StatelessWidget {
  const _CycleRow({required this.cycle});

  final CycleLog cycle;

  static const _months = [
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
    final start = cycle.startDate;
    final end = cycle.endDate;
    final range =
        '${start.day} ${_months[start.month - 1]} – '
        '${end.day} ${_months[end.month - 1]}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: AppColors.rose,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              range,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          Text(
            '${cycle.periodLength}d period · ${cycle.cycleLength}d cycle',
            style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 13,
          color: AppColors.inkFaint,
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Text(
            'Predictions are estimates from your logged cycles, not '
            'contraception or medical advice.',
            style: TextStyle(
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
      ],
    );
  }
}

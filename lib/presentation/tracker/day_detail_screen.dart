import 'package:flutter/material.dart';
import 'package:saalt/helper/care_helper.dart';
import 'package:saalt/helper/entry_store.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/cycle_log.dart';
import 'package:saalt/models/day_entry.dart';
import 'package:saalt/models/tracker_prefs.dart';
import 'package:saalt/presentation/tracker/widgets/care_suggestions.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_chart.dart';
import 'package:saalt/presentation/tracker/widgets/cycle_status_card.dart';
import 'package:saalt/presentation/tracker/widgets/log_today_card.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const _months = [
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

/// One day, opened from the calendar: what the cycle is doing on that date,
/// the entry form for it, what Saalt makes for it, and the history it sits in.
class DayDetailScreen extends StatefulWidget {
  const DayDetailScreen({super.key, required this.date});

  static const kDate = 'date';

  static Future open(BuildContext context, {required DateTime date}) {
    return context.push(AppRoutePaths.dayDetailScreen, extra: {kDate: date});
  }

  final DateTime date;

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  /// The day on show. Held in state rather than read from the widget so the
  /// arrows can walk through days without pushing a route each time.
  late DateTime _date;

  String? _flow;
  String? _mood;
  var _symptoms = <String>{};

  /// Its own controller, opted out of offset saving, so a day always opens
  /// at the top of its entry form rather than part-way down the statistics.
  final _scrollController = ScrollController(keepScrollOffset: false);

  @override
  void initState() {
    super.initState();
    _date = _dateOnly(widget.date);
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Whatever was saved against this day, so a day filled in earlier opens
  /// with its answers rather than blank.
  void _load() {
    final stored = EntryStore.forDate(_date);
    _flow = stored?.flow;
    _mood = stored?.mood;
    _symptoms = {...?stored?.symptoms};
  }

  void _goToDay(int by) {
    setState(() {
      _date = _date.add(Duration(days: by));
      _load();
      _scrollController.jumpTo(0);
    });
  }

  bool get _isToday => _date == _dateOnly(DateTime.now());

  bool get _isFuture => _date.isAfter(_dateOnly(DateTime.now()));

  String get _dateLabel =>
      '${_weekdays[_date.weekday - 1]}, ${_date.day} '
      '${_months[_date.month - 1]}';

  bool get _hasStoredEntry => EntryStore.hasEntry(_date);

  bool get _hasSelection =>
      _flow != null || _symptoms.isNotEmpty || _mood != null;

  DayEntry get _entry =>
      DayEntry(flow: _flow, symptoms: _symptoms, mood: _mood);

  /// True when this day is bleeding as far as the tracker knows: recorded, or
  /// predicted and not yet passed.
  bool get _isBleedingDay =>
      TrackerHelper.periodDayFor(_date) != null ||
      TrackerHelper.isPredictedDate(_date);

  /// What the cycle is doing on this date, in the order that matters: a
  /// recorded bleed beats a prediction, a prediction beats the fertile window.
  String get _headline {
    final bleedDay = TrackerHelper.periodDayFor(_date);
    if (bleedDay != null) return 'Period day $bleedDay';
    if (TrackerHelper.isPredictedDate(_date)) return 'Period expected';
    if (TrackerHelper.isFertileDate(_date)) return 'Fertile window';
    return 'Cycle day ${TrackerHelper.cycleDayFor(_date)}';
  }

  /// The supporting line. A day that has not happened cannot be described in
  /// the present tense, which is what the phase blurb does.
  String get _detail {
    if (TrackerHelper.periodDayFor(_date) != null) return 'Recorded bleeding';
    if (TrackerHelper.isPredictedDate(_date)) {
      return _isFuture ? 'Predicted, not recorded' : 'Expected, not recorded';
    }
    final phase = TrackerHelper.phaseForDate(_date);
    if (_isFuture) return 'Predicted ${phase.label.toLowerCase()}';
    return phase.blurb;
  }

  void _save() {
    final wasCleared = !_hasSelection;
    EntryStore.save(_date, _entry);
    setState(() {});

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          wasCleared
              ? 'Entry cleared for $_dateLabel'
              : 'Entry saved for $_dateLabel',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerPrefs>(
      valueListenable: TrackerSettings.prefs,
      builder: (context, prefs, _) => _build(context, prefs),
    );
  }

  Widget _build(BuildContext context, TrackerPrefs prefs) {
    final cycleDay = TrackerHelper.cycleDayFor(_date);
    final suggestions = CareHelper.suggestions(
      flow: _flow,
      isBleedingDay: _isBleedingDay,
    );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: _isToday ? 'Today' : _dateLabel,
              onBack: () => context.pop(),
              trailing: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Previous day',
                    onTap: () => _goToDay(-1),
                  ),
                  const SizedBox(width: 8),
                  CircleIconButton(
                    icon: Icons.chevron_right_rounded,
                    tooltip: 'Next day',
                    onTap: () => _goToDay(1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                key: const Key('day-body'),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                children: [
                  CycleStatusCard(
                    cycleDay: cycleDay,
                    cycleLength: TrackerHelper.averageCycle,
                    phase: TrackerHelper.phaseForDate(_date),
                    daysUntilNextPeriod: TrackerHelper.daysUntilNextPeriod,
                    headline: _headline,
                    detail: _detail,
                  ),

                  const SizedBox(height: 22),
                  LogTodayCard(
                    title: _isToday ? 'Log today' : 'Log $_dateLabel',
                    flow: _flow,
                    symptoms: _symptoms,
                    mood: _mood,
                    isSaved: _hasStoredEntry,
                    // A stored day can be saved empty, which clears it.
                    canSave: _hasSelection || _hasStoredEntry,
                    saveLabel: _saveLabel,
                    onFlow: (v) =>
                        setState(() => _flow = _flow == v ? null : v),
                    onSymptom: (v) => setState(() {
                      _symptoms.contains(v)
                          ? _symptoms.remove(v)
                          : _symptoms.add(v);
                    }),
                    onMood: (v) =>
                        setState(() => _mood = _mood == v ? null : v),
                    onSave: _save,
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    CareSuggestions(
                      products: suggestions,
                      reason: CareHelper.reasonFor(
                        flow: _flow,
                        isBleedingDay: _isBleedingDay,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  const _SectionLabel('Your statistics'),
                  const SizedBox(height: 12),
                  CycleChart(
                    cycles: TrackerHelper.history,
                    // The bars are logged cycles, so the average rule stays
                    // on the logged mean even when a length is set by hand.
                    averageCycle: TrackerHelper.loggedAverageCycle,
                    averagePeriod: TrackerHelper.loggedAveragePeriod,
                  ),
                  const SizedBox(height: 12),
                  _Averages(prefs: prefs),
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

  String get _saveLabel {
    if (!_hasStoredEntry) return 'Save entry';
    return _hasSelection ? 'Update entry' : 'Clear entry';
  }
}

class _Averages extends StatelessWidget {
  const _Averages({required this.prefs});

  final TrackerPrefs prefs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(
          value: '${TrackerHelper.averageCycle}',
          unit: 'days',
          // A length someone set by hand is not an average, and calling it
          // one would misreport their own data back to them.
          label: prefs.cycleLength == null ? 'Avg cycle' : 'Cycle length',
          accent: AppColors.rose,
        ),
        const SizedBox(width: 10),
        _Stat(
          value: '${TrackerHelper.averagePeriod}',
          unit: 'days',
          label: prefs.periodLength == null ? 'Avg period' : 'Period length',
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    final start = cycle.startDate;
    final end = cycle.endDate;
    final range =
        '${start.day} ${_months[start.month - 1]} – '
        '${end.day} ${_months[end.month - 1]}';

    // How this cycle sat against the logged mean. The chart shows the shape;
    // this says the number, which is what gets repeated to a clinician.
    final delta = cycle.cycleLength - TrackerHelper.loggedAverageCycle;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  range,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cycle.periodLength}d period · ${cycle.cycleLength}d cycle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _DeltaTag(delta: delta),
        ],
      ),
    );
  }
}

/// How far a cycle ran from the logged mean. Deliberately colourless: a longer
/// cycle is not a worse one.
class _DeltaTag extends StatelessWidget {
  const _DeltaTag({required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    final label = delta == 0
        ? 'on avg'
        : '${delta > 0 ? '+' : '−'}${delta.abs()}d';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.inkMuted,
        ),
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
  const _SectionLabel(this.text);

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

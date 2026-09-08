import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/cycle_log.dart';

class TrackerHelper {
  /// Recorded cycles, newest first. Relative to today so the screen stays live.
  static const history = <CycleLog>[
    CycleLog(startedDaysAgo: 13, periodLength: 5, cycleLength: 28),
    CycleLog(startedDaysAgo: 41, periodLength: 5, cycleLength: 29),
    CycleLog(startedDaysAgo: 70, periodLength: 4, cycleLength: 27),
    CycleLog(startedDaysAgo: 97, periodLength: 6, cycleLength: 30),
    CycleLog(startedDaysAgo: 127, periodLength: 5, cycleLength: 28),
  ];

  static CycleLog get current => history.first;

  /// Day 1 is the first day of bleeding, matching how every tracker counts.
  static int get cycleDay => current.startedDaysAgo + 1;

  /// Mean of the recorded cycles. The chart plots logged data, so its average
  /// rule stays on this even when the prediction is set by hand.
  static int get loggedAverageCycle =>
      (history.map((c) => c.cycleLength).reduce((a, b) => a + b) /
              history.length)
          .round();

  static int get loggedAveragePeriod =>
      (history.map((c) => c.periodLength).reduce((a, b) => a + b) /
              history.length)
          .round();

  /// What every prediction on the screen runs on: the length set in settings
  /// when there is one, otherwise the logged mean. Overriding it moves the
  /// calendar shading, the phases and the countdown together.
  static int get averageCycle =>
      TrackerSettings.current.cycleLength ?? loggedAverageCycle;

  static int get averagePeriod =>
      TrackerSettings.current.periodLength ?? loggedAveragePeriod;

  /// Spread between the shortest and longest recorded cycle. Clinicians care
  /// about variability, not just the mean.
  static int get variability {
    final lengths = history.map((c) => c.cycleLength).toList()..sort();
    return lengths.last - lengths.first;
  }

  static DateTime get nextPeriodStart =>
      current.startDate.add(Duration(days: averageCycle));

  static int get daysUntilNextPeriod =>
      nextPeriodStart.difference(_today).inDays;

  /// Ovulation is estimated at 14 days before the next period, with the
  /// fertile window the five days leading into it.
  static int get ovulationDay => averageCycle - 13;

  static bool isFertile(int day) =>
      day >= ovulationDay - 4 && day <= ovulationDay;

  static CyclePhase get phase => phaseFor(cycleDay);

  static CyclePhase phaseFor(int day) {
    if (day <= averagePeriod) return CyclePhase.menstrual;
    // Reuse the same window the calendar shades, so the headline label and
    // the calendar can never disagree about a given day.
    if (isFertile(day)) return CyclePhase.ovulation;
    if (day < ovulationDay) return CyclePhase.follicular;
    return CyclePhase.luteal;
  }

  /// Flow options, matching the scale these apps have settled on.
  static const flowLevels = ['None', 'Light', 'Medium', 'Heavy'];

  /// Kept short on purpose: a symptom list nobody scrolls is a list nobody
  /// fills in.
  static const symptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Tender breasts',
    'Fatigue',
    'Acne',
    'Back pain',
    'Nausea',
  ];

  static const moods = ['Good', 'Low', 'Anxious', 'Irritable', 'Calm'];

  /// Which day of its cycle [date] falls on. Day 1 is the first bleeding day.
  /// Future dates keep counting through projected cycles so the fertile window
  /// can be shaded in months that have not happened yet.
  static int cycleDayFor(DateTime date) {
    final day = _dateOnly(date);
    for (var i = 0; i < history.length; i++) {
      final cycle = history[i];
      final diff = day.difference(cycle.startDate).inDays;
      if (diff < 0) continue;
      // The newest cycle has no recorded end, so wrap it by the average to
      // project forwards instead of running off to day 60.
      if (i == 0) return diff % averageCycle + 1;
      if (diff < cycle.cycleLength) return diff + 1;
    }
    // Older than anything recorded: count backwards through average cycles.
    final back = history.last.startDate.difference(day).inDays;
    return averageCycle - (back - 1) % averageCycle;
  }

  static CyclePhase phaseForDate(DateTime date) => phaseFor(cycleDayFor(date));

  static bool isPeriodDate(DateTime date) {
    final day = _dateOnly(date);
    return history.any((cycle) {
      final diff = day.difference(cycle.startDate).inDays;
      return diff >= 0 && diff < cycle.periodLength;
    });
  }

  /// Which day of the bleed [date] is, 1-based, or null if it is not one.
  static int? periodDayFor(DateTime date) {
    final day = _dateOnly(date);
    for (final cycle in history) {
      final diff = day.difference(cycle.startDate).inDays;
      if (diff >= 0 && diff < cycle.periodLength) return diff + 1;
    }
    return null;
  }

  static bool isPredictedDate(DateTime date) {
    final diff = _dateOnly(date).difference(nextPeriodStart).inDays;
    return diff >= 0 && diff % averageCycle < averagePeriod;
  }

  static bool isFertileDate(DateTime date) =>
      !isPeriodDate(date) && isFertile(cycleDayFor(date));

  /// Bleeding days recorded in [month], as day-of-month numbers.
  static Set<int> periodDaysIn(DateTime month) => _daysIn(month, isPeriodDate);

  /// Days a period is expected to fall on, projected forwards so future
  /// months are not blank.
  static Set<int> predictedDaysIn(DateTime month) =>
      _daysIn(month, (d) => !isPeriodDate(d) && isPredictedDate(d));

  static Set<int> fertileDaysIn(DateTime month) =>
      _daysIn(month, isFertileDate);

  static Set<int> _daysIn(DateTime month, bool Function(DateTime) test) {
    final total = daysInMonth(month);
    final days = <int>{};
    for (var d = 1; d <= total; d++) {
      if (test(DateTime(month.year, month.month, d))) days.add(d);
    }
    return days;
  }

  static int daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  /// Headline status. Past the prediction it counts the delay, the way the
  /// trackers people already use do.
  static String get statusLabel {
    final due = daysUntilNextPeriod;
    if (due < 0) return 'Delayed by ${-due} days';
    if (due == 0) return 'Period expected today';
    return 'Period in $due ${due == 1 ? 'day' : 'days'}';
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}

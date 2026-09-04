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

  static int get averageCycle =>
      (history.map((c) => c.cycleLength).reduce((a, b) => a + b) /
              history.length)
          .round();

  static int get averagePeriod =>
      (history.map((c) => c.periodLength).reduce((a, b) => a + b) /
              history.length)
          .round();

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

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}

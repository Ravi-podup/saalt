/// One recorded cycle: when bleeding started, how long it lasted, and how long
/// the whole cycle ran before the next one began.
class CycleLog {
  const CycleLog({
    required this.startedDaysAgo,
    required this.periodLength,
    required this.cycleLength,
  });

  /// Kept relative to today so the screen never shows stale dates.
  final int startedDaysAgo;

  final int periodLength;
  final int cycleLength;

  /// Date-only, so two reads in the same day agree. Using the raw clock here
  /// made day differences truncate unpredictably.
  DateTime get startDate {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: startedDaysAgo));
  }

  DateTime get endDate => startDate.add(Duration(days: periodLength - 1));
}

/// Where in the cycle today falls.
enum CyclePhase {
  menstrual('Period', 'Bleeding'),
  follicular('Follicular', 'Building up'),
  ovulation('Ovulation window', 'Most fertile'),
  luteal('Luteal', 'Winding down');

  const CyclePhase(this.label, this.blurb);

  final String label;
  final String blurb;
}

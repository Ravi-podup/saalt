/// Tracker preferences. Lengths are nullable on purpose: null means "work it
/// out from my logs", which is the right default until someone says otherwise.
class TrackerPrefs {
  const TrackerPrefs({
    this.periodLength,
    this.cycleLength,
    this.weekStartsOnSunday = false,
    this.periodReminder = true,
    this.ovulationReminder = false,
  });

  /// Bounds taken from what the trackers people already use accept, and from
  /// what is clinically plausible: a 45 day cycle is long but real.
  static const minPeriod = 1;
  static const maxPeriod = 10;
  static const minCycle = 20;
  static const maxCycle = 45;

  final int? periodLength;
  final int? cycleLength;

  /// Sunday-first calendars are the norm in the US, Monday-first elsewhere.
  final bool weekStartsOnSunday;

  final bool periodReminder;
  final bool ovulationReminder;

  bool get overridesLengths => periodLength != null || cycleLength != null;

  TrackerPrefs copyWith({
    int? periodLength,
    int? cycleLength,
    bool? weekStartsOnSunday,
    bool? periodReminder,
    bool? ovulationReminder,
  }) {
    return TrackerPrefs(
      periodLength: periodLength ?? this.periodLength,
      cycleLength: cycleLength ?? this.cycleLength,
      weekStartsOnSunday: weekStartsOnSunday ?? this.weekStartsOnSunday,
      periodReminder: periodReminder ?? this.periodReminder,
      ovulationReminder: ovulationReminder ?? this.ovulationReminder,
    );
  }

  /// Hands the lengths back to the logged history. [copyWith] cannot express
  /// this, since passing null there means "leave it alone".
  TrackerPrefs withLoggedLengths() {
    return TrackerPrefs(
      weekStartsOnSunday: weekStartsOnSunday,
      periodReminder: periodReminder,
      ovulationReminder: ovulationReminder,
    );
  }
}

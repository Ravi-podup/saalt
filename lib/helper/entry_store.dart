import 'package:flutter/foundation.dart';
import 'package:saalt/models/day_entry.dart';

/// Logged days, shared across the calendar and a day's entry form. Without
/// this a day you filled in yesterday came back blank, and the calendar had
/// no way to show which days had anything on them.
///
/// In memory only, like the bag: nothing in this app survives a restart yet.
class EntryStore {
  EntryStore._();

  static final entries = ValueNotifier<Map<String, DayEntry>>({});

  /// Date-only key, so two reads on the same day agree whatever the clock is.
  static String keyFor(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  static DayEntry? forDate(DateTime date) => entries.value[keyFor(date)];

  static bool hasEntry(DateTime date) => forDate(date) != null;

  /// Saving nothing clears the day rather than storing a blank entry, so the
  /// calendar marker means "there is something here".
  static void save(DateTime date, DayEntry entry) {
    final next = Map<String, DayEntry>.of(entries.value);
    if (entry.isEmpty) {
      next.remove(keyFor(date));
    } else {
      next[keyFor(date)] = _detached(entry);
    }
    entries.value = next;
  }

  /// A copy that shares nothing with the caller. The entry form keeps editing
  /// its own symptom set after saving, and without this those unsaved taps
  /// reached back into what was already stored.
  static DayEntry _detached(DayEntry entry) => DayEntry(
    flow: entry.flow,
    symptoms: Set.unmodifiable(entry.symptoms),
    mood: entry.mood,
  );

  static Set<int> loggedDaysIn(DateTime month) {
    final days = <int>{};
    final total = DateTime(month.year, month.month + 1, 0).day;
    for (var d = 1; d <= total; d++) {
      if (hasEntry(DateTime(month.year, month.month, d))) days.add(d);
    }
    return days;
  }

  static int get count => entries.value.length;

  @visibleForTesting
  static void clear() => entries.value = {};
}

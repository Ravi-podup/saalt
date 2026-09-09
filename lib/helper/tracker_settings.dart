import 'package:flutter/foundation.dart';
import 'package:saalt/models/tracker_prefs.dart';

/// Tracker preferences, shared across the calendar, a day's entry and the
/// settings screen. Held in memory like the cart: nothing in this app persists
/// across launches yet.
class TrackerSettings {
  TrackerSettings._();

  static final prefs = ValueNotifier<TrackerPrefs>(const TrackerPrefs());

  static TrackerPrefs get current => prefs.value;

  static void update(TrackerPrefs next) => prefs.value = next;

  /// Steps a length within its bounds, so the buttons can be held down
  /// without running the cycle into nonsense.
  static void stepCycle(int by, {required int from}) {
    final next = (from + by).clamp(
      TrackerPrefs.minCycle,
      TrackerPrefs.maxCycle,
    );
    prefs.value = prefs.value.copyWith(cycleLength: next);
  }

  static void stepPeriod(int by, {required int from}) {
    final next = (from + by).clamp(
      TrackerPrefs.minPeriod,
      TrackerPrefs.maxPeriod,
    );
    prefs.value = prefs.value.copyWith(periodLength: next);
  }

  @visibleForTesting
  static void reset() => prefs.value = const TrackerPrefs();
}

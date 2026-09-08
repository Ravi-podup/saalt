import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/tracker_prefs.dart';
import 'package:saalt/presentation/tracker/period_tracker_screen.dart';
import 'package:saalt/presentation/tracker/tracker_settings_screen.dart';

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Which column of the seven a calendar cell sits in.
int _columnOf(WidgetTester tester, Finder cell) {
  final grid = find.byKey(const Key('calendar-grid'));
  final left = tester.getTopLeft(grid).dx;
  final columnWidth = tester.getSize(grid).width / 7;
  return ((tester.getCenter(cell).dx - left) / columnWidth).floor();
}

Finder _dayCell(String day) => find.descendant(
  of: find.byKey(const Key('calendar-grid')),
  matching: find.text(day),
);

Future<void> _openSettings(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));
  await tester.tap(find.byIcon(Icons.tune_rounded));
  await tester.pumpAndSettle();
}

void main() {
  setUp(TrackerSettings.reset);
  tearDown(TrackerSettings.reset);

  group('lengths', () {
    test('both start from the logged history', () {
      expect(TrackerSettings.current.periodLength, isNull);
      expect(TrackerSettings.current.cycleLength, isNull);
      expect(TrackerHelper.averageCycle, TrackerHelper.loggedAverageCycle);
      expect(TrackerHelper.averagePeriod, TrackerHelper.loggedAveragePeriod);
    });

    test('a custom cycle length moves every prediction with it', () {
      final wasDue = TrackerHelper.daysUntilNextPeriod;
      final wasOvulation = TrackerHelper.ovulationDay;

      TrackerSettings.stepCycle(7, from: TrackerHelper.averageCycle);

      expect(TrackerHelper.averageCycle, TrackerHelper.loggedAverageCycle + 7);
      expect(TrackerHelper.daysUntilNextPeriod, wasDue + 7);
      expect(TrackerHelper.ovulationDay, wasOvulation + 7);
      // The logged mean is untouched: the bars are still the recorded cycles.
      expect(TrackerHelper.loggedAverageCycle, 28);
    });

    test('a custom period length widens the bleeding prediction', () {
      TrackerSettings.stepPeriod(3, from: TrackerHelper.averagePeriod);

      expect(TrackerHelper.averagePeriod, 8);
      expect(
        TrackerHelper.predictedDaysIn(TrackerHelper.nextPeriodStart).length +
            TrackerHelper.predictedDaysIn(
              DateTime(
                TrackerHelper.nextPeriodStart.year,
                TrackerHelper.nextPeriodStart.month + 1,
              ),
            ).length,
        greaterThanOrEqualTo(8),
      );
      // Recorded bleeds keep their own lengths.
      expect(TrackerHelper.current.periodLength, 5);
    });

    test('the bounds hold, however hard the buttons are pressed', () {
      for (var i = 0; i < 40; i++) {
        TrackerSettings.stepCycle(1, from: TrackerHelper.averageCycle);
      }
      expect(TrackerHelper.averageCycle, TrackerPrefs.maxCycle);

      for (var i = 0; i < 60; i++) {
        TrackerSettings.stepCycle(-1, from: TrackerHelper.averageCycle);
      }
      expect(TrackerHelper.averageCycle, TrackerPrefs.minCycle);

      for (var i = 0; i < 20; i++) {
        TrackerSettings.stepPeriod(1, from: TrackerHelper.averagePeriod);
      }
      expect(TrackerHelper.averagePeriod, TrackerPrefs.maxPeriod);

      for (var i = 0; i < 20; i++) {
        TrackerSettings.stepPeriod(-1, from: TrackerHelper.averagePeriod);
      }
      expect(TrackerHelper.averagePeriod, TrackerPrefs.minPeriod);
    });

    test('handing the lengths back keeps the other preferences', () {
      TrackerSettings.update(
        const TrackerPrefs(
          periodLength: 7,
          cycleLength: 40,
          weekStartsOnSunday: true,
          ovulationReminder: true,
        ),
      );

      TrackerSettings.update(TrackerSettings.current.withLoggedLengths());

      expect(TrackerSettings.current.periodLength, isNull);
      expect(TrackerSettings.current.cycleLength, isNull);
      expect(TrackerSettings.current.weekStartsOnSunday, isTrue);
      expect(TrackerSettings.current.ovulationReminder, isTrue);
    });
  });

  group('settings screen', () {
    testWidgets('reachable from the calendar header', (tester) async {
      _phone(tester);
      await _openSettings(tester);

      expect(find.byType(TrackerSettingsScreen), findsOneWidget);
      expect(find.text('Period length'), findsOneWidget);
      expect(find.text('Cycle length'), findsOneWidget);
      expect(find.text('First day of week'), findsOneWidget);
    });

    testWidgets('the steppers move the numbers and say who set them', (
      tester,
    ) async {
      _phone(tester);
      await _openSettings(tester);

      expect(find.text('From your logs'), findsNWidgets(2));
      expect(find.text('${TrackerHelper.loggedAverageCycle}'), findsOneWidget);

      await tester.tap(find.byTooltip('Increase Cycle length'));
      await tester.pumpAndSettle();

      expect(
        find.text('${TrackerHelper.loggedAverageCycle + 1}'),
        findsOneWidget,
      );
      expect(find.text('Set by you'), findsOneWidget);
      expect(find.text('From your logs'), findsOneWidget);
    });

    testWidgets('a way back to the logged averages appears once overridden', (
      tester,
    ) async {
      _phone(tester);
      await _openSettings(tester);

      expect(find.text('Use my logged averages'), findsNothing);

      await tester.tap(find.byTooltip('Increase Period length'));
      await tester.pumpAndSettle();
      expect(find.text('Use my logged averages'), findsOneWidget);

      await tester.tap(find.text('Use my logged averages'));
      await tester.pumpAndSettle();

      expect(find.text('Use my logged averages'), findsNothing);
      expect(find.text('From your logs'), findsNWidgets(2));
      expect(TrackerHelper.averagePeriod, TrackerHelper.loggedAveragePeriod);
    });

    testWidgets('the minus button stops at the bound instead of going on', (
      tester,
    ) async {
      _phone(tester);
      TrackerSettings.update(
        const TrackerPrefs(cycleLength: TrackerPrefs.minCycle),
      );
      await _openSettings(tester);

      final minus = find.byTooltip('Decrease Cycle length');
      expect(
        tester
            .widget<InkWell>(
              find.descendant(of: minus, matching: find.byType(InkWell)),
            )
            .onTap,
        isNull,
      );
    });

    testWidgets('reminders toggle and hold', (tester) async {
      _phone(tester);
      await _openSettings(tester);

      // Period due is on by default; the fertile window is not.
      expect(TrackerSettings.current.periodReminder, isTrue);
      expect(TrackerSettings.current.ovulationReminder, isFalse);

      await tester.tap(find.text('Fertile window'));
      await tester.pumpAndSettle();
      // The label is not the control, so the switch itself is what moves.
      expect(TrackerSettings.current.ovulationReminder, isFalse);

      await tester.tap(find.byType(Switch).last);
      await tester.pumpAndSettle();
      expect(TrackerSettings.current.ovulationReminder, isTrue);
    });

    testWidgets('reset clears everything at once', (tester) async {
      _phone(tester);
      TrackerSettings.update(
        const TrackerPrefs(
          periodLength: 8,
          cycleLength: 40,
          weekStartsOnSunday: true,
          periodReminder: false,
          ovulationReminder: true,
        ),
      );
      await _openSettings(tester);

      await tester.tap(find.text('Reset all tracker settings'));
      await tester.pumpAndSettle();

      expect(TrackerSettings.current.periodLength, isNull);
      expect(TrackerSettings.current.cycleLength, isNull);
      expect(TrackerSettings.current.weekStartsOnSunday, isFalse);
      expect(TrackerSettings.current.periodReminder, isTrue);
      expect(TrackerSettings.current.ovulationReminder, isFalse);
    });
  });

  group('week start', () {
    testWidgets('the calendar shifts the whole month, not just the header', (
      tester,
    ) async {
      _phone(tester);
      await tester.pumpWidget(const MaterialApp(home: PeriodTrackerScreen()));

      final now = DateTime.now();
      final firstOfMonth = DateTime(now.year, now.month);

      // Monday-first: Dart's own weekday order.
      expect(
        _columnOf(tester, _dayCell('1')),
        firstOfMonth.weekday - 1,
        reason: 'Monday-first should place the 1st on its Dart weekday',
      );

      TrackerSettings.update(
        TrackerSettings.current.copyWith(weekStartsOnSunday: true),
      );
      await tester.pumpAndSettle();

      expect(
        _columnOf(tester, _dayCell('1')),
        firstOfMonth.weekday % 7,
        reason: 'Sunday-first should wrap Sunday round to the front',
      );
    });

    testWidgets('changing it on the settings screen reaches the calendar', (
      tester,
    ) async {
      _phone(tester);
      await _openSettings(tester);

      await tester.tap(find.text('Sunday'));
      await tester.pumpAndSettle();
      expect(TrackerSettings.current.weekStartsOnSunday, isTrue);

      // The shared header uses its own back button, not a Material one.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      expect(
        _columnOf(tester, _dayCell('1')),
        DateTime(now.year, now.month).weekday % 7,
      );
    });
  });
}
